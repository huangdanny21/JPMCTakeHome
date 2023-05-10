//
//  WeatherService.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import Foundation

protocol WeatherProtocol {
    func getWeatherData(for city: String, completion: @escaping (Result<WeatherInfo, Error>) -> Void)
}

class WeatherService: WeatherProtocol {
    private let apiKey = ""
    var currentWeather: WeatherInfo?
    
    // MARK: - Public
    
    /**
     Fetches weather data for the specified city.
     
     - Parameters:
        - city: The name of the city for which to fetch weather data.
        - completion: A closure to be called when the weather data retrieval is completed. It contains a `Result` object that either holds a `WeatherInfo` object on success or an `Error` on failure.

     */
    func getWeatherData(for city: String, completion: @escaping (Result<WeatherInfo, Error>) -> Void) {
        guard let url = createURL(for: city) else {
            completion(.failure(WeatherError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(WeatherError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                let weather = self?.parseWeatherData(weatherData)
                
                if let weather = weather {
                    self?.currentWeather = weather
                    completion(.success(weather))
                } else {
                    completion(.failure(WeatherError.invalidData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private
    
    private func createURL(for city: String) -> URL? {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        return URL(string: urlString)
    }
    
    private func parseWeatherData(_ data: WeatherData) -> WeatherInfo? {
        guard let temperature = data.main.temp, let humidity = data.main.humidity, let weather = data.weather.first else {
            return nil
        }
        
        let weatherDescription = weather.weatherDescription
        let iconCode = weather.icon ?? ""
        
        let weatherIconURL = createWeatherIconURL(iconCode: iconCode)
        let iconURLString = weatherIconURL.absoluteString // Convert URL to String
        
        return WeatherInfo(temp: temperature, humidity: humidity, weatherDescription: weatherDescription, icon: iconURLString)
    }

    
    private func createWeatherIconURL(iconCode: String) -> URL {
        let urlString = "http://openweathermap.org/img/w/\(iconCode).png"
        return URL(string: urlString)!
    }
}

enum WeatherError: Error {
    case invalidURL
    case noData
    case invalidData
}
