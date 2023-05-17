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
        - completion: A closure to be called when the weather data retrieval is completed. It contains a `Result` object that either holds a `WeatherData` object on success or an `Error` on failure.
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
                UserDefaults.standard.set(city, forKey: WeatherViewController.lastSearchedCityKey)

                completion(.success(weatherData))
                
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
        - completion: A closure to be called when the weather data retrieval is completed. It contains a `Result` object that either holds a `WeatherData` object on success or an `Error` on failure.
     */
    func getCurrentLocationWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let url = createURL(for: String(latitude), String(longitude)) else {
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
                completion(.failure(WeatherError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    
    // MARK: - Private
    
    private func createURL(for city: String) -> URL? {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&units=metric&appid=\(apiKey)"
        return URL(string: urlString)
    }
    
    private func createURL(for latitude: String, _ longitude: String) -> URL? {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        return URL(string: urlString)
    }
    
    private func createWeatherIconURL(iconCode: String) -> String {
        "http://openweathermap.org/img/w/\(iconCode).png"
    }
}

enum WeatherError: Error {
    case invalidURL
    case noData
    case invalidData
    case invalidResponse
}
