//
//  WeatherViewController.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private let lastSearchedCityKey = "LastSearchedCity"
    
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
    
    // MARK: - Constructor
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = WeatherViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupWeatherView()
        setupBindings()
        
        // Load the last searched city from UserDefaults
        let lastSearchedCity = UserDefaults.standard.string(forKey: lastSearchedCityKey)
        
        // If a last searched city exists, call the searchWeather method
        if let city = lastSearchedCity {
            viewModel.searchWeather(for: city)
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
                    self?.weatherView.configure(with: self?.viewModel.lastSearchedWeatherInfo)
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func getLastSearchedCity() -> String? {
        UserDefaults.standard.string(forKey: "LastSearchedCity")
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text, !city.isEmpty else {
            showAlert(with: "Error", message: "Please enter a city.")
            return
        }
        // Store the searched city in UserDefaults
        UserDefaults.standard.set(city, forKey: lastSearchedCityKey)
        viewModel.searchWeather(for: city)
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
