//
//  WeatherViewModelTests.swift
//  JPMCTakeHomeTests
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import XCTest

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        
        // Create an instance of the mock service
        mockService = MockWeatherService()
        
        // Create an instance of the view model with the mock service
        viewModel = WeatherViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        
        super.tearDown()
    }
    
    func testSearchWeather_Success() {
        // Define the expected weather data
        let expectedWeatherData = WeatherData(coord: Coord(lon: 0, lat: 0), weather: [], base: "", main: Main(temp: 0, feels_like: 0, temp_min: 0, temp_max: 0, pressure: 0, humidity: 0), visibility: 0, wind: Wind(speed: 0, deg: 0), clouds: Clouds(all: 0), dt: 0, sys: Sys(type: 0, id: 0, country: "", sunrise: 0, sunset: 0), timezone: 0, id: 0, name: "Sunnyvale", cod: 0)
        
        // Create an expectation for the onWeatherInfoUpdate closure to be called
        let updateExpectation = expectation(description: "onWeatherInfoUpdate should be called")
        updateExpectation.expectedFulfillmentCount = 1 // Set the expected fulfillment count to 1
        
        // Set up the closure to be called
        viewModel.onWeatherInfoUpdate = { weatherData in
            XCTAssertEqual(weatherData!.name, expectedWeatherData.name)
            updateExpectation.fulfill()
        }
        
        // Perform the search
        viewModel.searchWeather(for: "Sunnyvale")
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testSearchWeather_Failure() {
        // Set up the mock service to return a failure response
        mockService.shouldSucceed = false
        
        // Create an expectation for the onError closure to be called
        let errorExpectation = expectation(description: "onError should be called")
        errorExpectation.expectedFulfillmentCount = 1 // Set the expected fulfillment count to 1
        
        // Set up the closure to be called
        viewModel.onError = { error in
            // Add assertions to verify the error handling
            XCTAssertNotNil(error)
            XCTAssertEqual(error.localizedDescription, "Failed to get weather data")
            
            errorExpectation.fulfill()
        }
        
        // Perform the search
        viewModel.searchWeather(for: "InvalidCity")
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }

}
