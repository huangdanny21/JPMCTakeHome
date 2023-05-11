//
//  WeatherViewController.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private let locationManager = CLLocationManager()
    static let lastSearchedCityKey = "LastSearchedCity"
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    private lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let viewModel: WeatherViewModel
    private let weatherService: WeatherService // Add weatherService property
    
    // MARK: - Constructor
    
    init(viewModel: WeatherViewModel, weatherService: WeatherService) {
        self.viewModel = viewModel
        self.weatherService = weatherService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = WeatherViewModel()
        self.weatherService = WeatherService()
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupWeatherView()
        setupBindings()
        
        // Load the last searched city from UserDefaults
        let lastSearchedCity = UserDefaults.standard.string(forKey: WeatherViewController.lastSearchedCityKey)
        
        // If a last searched city exists, call the searchWeather method
        if let city = lastSearchedCity {
            viewModel.searchWeather(for: city)
        } else {
            // We dont have a last searched city
            // so we display the user's current location if it's authorized!
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Private
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupWeatherView() {
        view.addSubview(weatherView)
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onWeatherInfoUpdate = { [weak self] weatherInfo in
            DispatchQueue.main.async {
                if let weatherInfo = weatherInfo {
                    self?.weatherView.configure(with: weatherInfo)
                } else {
                    // If weatherInfo is nil, display the last searched weather info
                    if let lastSearched = self?.viewModel.lastSearchedWeatherInfo {
                        self?.weatherView.configure(with: lastSearched)
                    } else {
                        // Blank screen
                    }
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(with: "Not Found", message: "Location not found")
            }
        }
    }
    
    private func getCurrentLocationWeather() {
        guard let userLocation = locationManager.location else {
            // Unable to retrieve user's location
            return
        }

        // Retrieve weather data using user's location coordinates
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude

        // Make API call with latitude and longitude to get weather data
        weatherService.getCurrentLocationWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let weatherInfo):
                // Store the searched city in UserDefaults
                self?.viewModel.onWeatherInfoUpdate?(weatherInfo)
            case .failure(let error):
                self?.viewModel.onError?(error)
            }
        }
    }

}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text, !city.isEmpty else {
            showAlert(with: "Error", message: "Please enter a city.")
            return
        }
                
        viewModel.searchWeather(for: city)
        
        // Dismiss the search bar
        searchController.dismiss(animated: true, completion: nil)
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // User granted location access permission, retrieve weather data
            getCurrentLocationWeather()
        }
    }
}

extension WeatherViewController {
    func showAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
