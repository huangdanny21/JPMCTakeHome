//
//  WeatherInfo.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import Foundation

struct WeatherData: Codable {
    let main: WeatherInfo
    let weather: [WeatherInfo]
}

struct WeatherInfo: Codable {
    let temp: Double?
    let humidity: Int?
    let weatherDescription: String?
    let icon: String?
}
