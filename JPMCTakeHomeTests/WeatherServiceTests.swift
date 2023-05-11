//
//  WeatherServiceTests.swift
//  JPMCTakeHomeTests
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import XCTest
import CoreLocation

class MockWeatherService: WeatherProtocol {
    func getCurrentLocationWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if shouldSucceed {
            // Create a mock WeatherData object with dummy values
            let weatherData = WeatherData(
                coord: Coord(lon: longitude, lat: latitude),
                weather: [],
                base: "base",
                main: Main(temp: 25.0, feels_like: 26.0, temp_min: 24.0, temp_max: 26.0, pressure: 1010, humidity: 60),
                visibility: 10000,
                wind: Wind(speed: 5.0, deg: 180),
                clouds: Clouds(all: 20),
                dt: Date().timeIntervalSince1970,
                sys: Sys(type: 1, id: 1234, country: "US", sunrise: Date().timeIntervalSince1970, sunset: Date().timeIntervalSince1970),
                timezone: 0,
                id: 12345,
                name: "Mock City",
                cod: 200
            )
            
            completion(.success(weatherData))
        } else {
            // Create a mock error
            let error = NSError(domain: "MockServiceErrorDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Mock service error"])
            completion(.failure(error))
        }
    }
    
    var shouldSucceed: Bool = true
    
    func getWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        if shouldSucceed {
            let mockWeatherData = WeatherData(
                coord: Coord(lon: 0, lat: 0),
                weather: [],
                base: "",
                main: Main(temp: 20, feels_like: 0, temp_min: 0, temp_max: 0, pressure: 0, humidity: 0),
                visibility: 0,
                wind: Wind(speed: 0, deg: 0),
                clouds: Clouds(all: 0),
                dt: 0,
                sys: Sys(type: 0, id: 0, country: "", sunrise: 0, sunset: 0),
                timezone: 0,
                id: 0,
                name: city,
                cod: 0
            )
            
            completion(.success(mockWeatherData))
        } else {
            let error = NSError(domain: "MockWeatherService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get weather data"])
            completion(.failure(error))
        }
    }
}


final class WeatherServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchWeather() {
        let service = MockWeatherService()
        let viewModel = WeatherViewModel(service: service)
        
        // Test successful response
        service.shouldSucceed = true
        viewModel.searchWeather(for: "Sunnyvale")
        
        // Assert the expected weather data in the view model
        XCTAssertEqual(viewModel.weatherInfo?.name, "Sunnyvale")
        XCTAssertEqual(viewModel.weatherInfo?.main.temp, 20)
        // Add more assertions for other properties
    }
    
    func testGetCurrentLocationWeather() {
        // Create a mock location
        let latitude: CLLocationDegrees = 37.7749
        let location = CLLocation(latitude: latitude, longitude: longitude)

        // Create an instance of the WeatherService
        let weatherService = MockWeatherService()

        // Define the expectation
        let expectation = XCTestExpectation(description: "Fetch current location weather")

        // Call the getCurrentLocationWeather method
        weatherService.getCurrentLocationWeather(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let weatherData):
                // Assert the returned weather data is not nil
                XCTAssertNotNil(weatherData)
                
                // Add more assertions to validate the weather data

            case .failure(let error):
                XCTFail("Error occurred: \(error)")
            }

            // Fulfill the expectation
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }

}
