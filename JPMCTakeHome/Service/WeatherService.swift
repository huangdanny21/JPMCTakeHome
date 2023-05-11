//
//  WeatherService.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import Foundation
import SDWebImage
import CoreLocation

protocol WeatherProtocol {
    func getWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void)
    func getCurrentLocationWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherData, Error>) -> Void)
}

class WeatherService: WeatherProtocol {
    private let apiKey = "ed9ee886f8c4fc1a165a5f0b797e5503"

    // MARK: - Public
    
    /**
     Fetches weather data for the specified city.
     
     - Parameters:
        - city: The name of the city for which to fetch weather data.
        - completion: A closure to be called when the weather data retrieval is completed. It contains a `Result` object that either holds a `WeatherInfo` object on success or an `Error` on failure.
     */
    func getWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let url = createURL(for: city) else {
            completion(.failure(WeatherError.invalidURL))
            return
        }
        
        print("Request URL:", url.absoluteString)

        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(WeatherError.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON String:", jsonString)
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
//                let weather = self.parseWeatherData(weatherData)
                completion(.success(weatherData))

//                if let weather = weather {
//                    completion(.success(weather))
//                } else {
//                    completion(.failure(WeatherError.invalidData))
//                }
            } catch {
                completion(.failure(WeatherError.invalidData))
            }
        }
        
        task.resume()
    }
    
    /**
     Fetches weather data for the current location using latitude and longitude coordinates.
     
     - Parameters:
        - latitude: The latitude coordinate of the location.
        - longitude: The longitude coordinate of the location.
        - completion: A closure to be called when the weather data retrieval is completed. It contains a `Result` object that either holds a `WeatherInfo` object on success or an `Error` on failure.
     */
    func getCurrentLocationWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let url = createURL(for: String(latitude), String(longitude)) else {
            completion(.failure(WeatherError.invalidURL))
            return
        }
        
        print("Request URL:", url.absoluteString)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle the response and parse weather data
            // ...
        }
        
        task.resume()
    }
    
    // MARK: - Private
    
    private func createURL(for city: String) -> URL? {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)"
        return URL(string: urlString)
    }
    
    private func createURL(for latitude: String, _ longitude: String) -> URL? {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        return URL(string: urlString)
    }
    
//    private func parseWeatherData(_ data: WeatherData) -> Weather? {
//        guard let temperature = data.main.temp, let humidity = data.main.humidity, let weather = data.weather.first else {
//            return nil
//        }
//
//        let weatherDescription = weather.weatherDescription
//        let iconCode = weather.icon ?? ""
//
//        let weatherIconURL = createWeatherIconURL(iconCode: iconCode)
//
//        return Weather(temp: temperature, humidity: humidity, weatherDescription: weatherDescription, icon: weatherIconURL)
//    }
    
    private func createWeatherIconURL(iconCode: String) -> String {
        return "http://openweathermap.org/img/w/\(iconCode).png"
    }
}

enum WeatherError: Error {
    case invalidURL
    case noData
    case invalidData
}
