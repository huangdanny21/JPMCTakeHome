//
//  WeatherInfo.swift
//  JPMCTakeHome
//
//  Created by Zhi Yong Huang on 5/10/23.
//

import Foundation

struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable, Equatable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable, Equatable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable, Equatable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable, Equatable {
    let all: Int
}

struct Sys: Codable, Equatable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

extension WeatherData: Equatable {
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        // Compare all the properties for equality
        return lhs.coord == rhs.coord &&
            lhs.weather == rhs.weather &&
            lhs.base == rhs.base &&
            lhs.main == rhs.main &&
            lhs.visibility == rhs.visibility &&
            lhs.wind == rhs.wind &&
            lhs.clouds == rhs.clouds &&
            lhs.dt == rhs.dt &&
            lhs.sys == rhs.sys &&
            lhs.timezone == rhs.timezone &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.cod == rhs.cod
    }
}
