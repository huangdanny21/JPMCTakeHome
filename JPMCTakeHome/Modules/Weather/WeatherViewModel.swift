//
//  WeatherViewModel.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit

class WeatherViewModel {
    private let service: WeatherProtocol
    var weatherInfo: WeatherInfo?
    var onWeatherInfoUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    // MARK: - Constructor
    
    init(service: WeatherProtocol = WeatherService()) {
        self.service = service
    }
    
    // MARK: - Public
    
    func searchWeather(for city: String) {
        getWeatherData(for: city)
    }
    
    func getWeatherData(for city: String) {
        service.getWeatherData(for: city) { [weak self] result in
            switch result {
            case .success(let weatherInfo):
                self?.weatherInfo = weatherInfo
                self?.onWeatherInfoUpdate?()
                
                // Store the last searched city
                self?.saveLastSearchedCity(city)
                
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    // MARK: - Private
    
    private func saveLastSearchedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: "LastSearchedCity")
    }
}
