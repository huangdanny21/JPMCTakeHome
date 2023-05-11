//
//  WeatherViewModel.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import UIKit

class WeatherViewModel {
    private let service: WeatherProtocol
    var lastSearchedWeatherInfo: WeatherData?

    var weatherInfo: WeatherData?
    var onWeatherInfoUpdate: ((WeatherData?) -> Void)?
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
                
                // Cache the last searched weather info
                self?.lastSearchedWeatherInfo = weatherInfo
                self?.onWeatherInfoUpdate?(weatherInfo)
                
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}
