//
//  WeatherViewController.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit

class WeatherViewController: UIViewController {
    private lazy var searchController: UISearchController = { UISearchController() }()
    
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
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupWeatherView()
        setupBindings()
        
        if let lastSearchedCity = getLastSearchedCity() {
            viewModel.searchWeather(for: lastSearchedCity)
        }
    }
    
    // MARK: - Private
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupWeatherView() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onWeatherInfoUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.weatherView.configure(with: self?.viewModel.weatherInfo)
                self?.searchController.isActive = false
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
        guard let city = weatherView.cityTextField.text, !city.isEmpty else {
            showAlert(with: "Error", message: "Please enter a city.")
            return
        }
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

