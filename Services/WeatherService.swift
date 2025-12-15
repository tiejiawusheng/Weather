//
//  WeatherService.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//
import Foundation
import UIKit

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResponse
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse
    func loadIcon(iconCode: String) async throws -> UIImage
}

actor WeatherService: WeatherServiceProtocol {
    private let apiKey = "797f6a07608bfc63f3301b7e69be212e" 
    private let cache = ImageCache.shared
    
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let encoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(encoded)&appid=\(apiKey)&units=imperial"
        return try await fetch(from: urlStr)
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial"
        return try await fetch(from: urlStr)
    }
    
    private func fetch(from urlString: String) async throws -> WeatherResponse {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            if let errorResp = try? decoder.decode(WeatherErrorResponse.self, from: data) {
                throw NSError(domain: "", code: Int(errorResp.cod) ?? 0, userInfo: [NSLocalizedDescriptionKey: errorResp.message])
            }
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(WeatherResponse.self, from: data)
    }
    
    func loadIcon(iconCode: String) async throws -> UIImage {
        if let cached = cache.object(forKey: iconCode as NSString) {
            return cached
        }
        
        let urlStr = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        guard let url = URL(string: urlStr) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
        
        cache.setObject(image, forKey: iconCode as NSString)
        return image
    }
}
