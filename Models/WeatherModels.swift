//
//  WeatherModels.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

struct WeatherErrorResponse: Codable {
    let cod: String
    let message: String
}
