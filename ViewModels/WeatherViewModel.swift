//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import Foundation
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    private let userDefaults: UserDefaults
    
    @Published var weather: WeatherResponse?
    @Published var iconURL: URL?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    var lastSearchedCity: String? {
        userDefaults.string(forKey: "lastCity")
    }
    
    init(
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol,
        userDefaults: UserDefaults = .standard
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.userDefaults = userDefaults
        
        Task {
            await loadInitialWeather()
        }
    }
    
    private func loadInitialWeather() async {
        if let lastCity = lastSearchedCity {
            await fetchWeather(for: lastCity)
        } else {
            await requestLocationAndFetch()
        }
    }
    
    func fetchWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await weatherService.fetchWeather(for: city)
            updateUI(with: response, city: city)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    func fetchWeather(lat: Double, lon: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await weatherService.fetchWeather(lat: lat, lon: lon)
            updateUI(with: response, city: response.name)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func requestLocationAndFetch() async {
        let authorized = await locationService.requestPermission()
        guard authorized else {
            errorMessage = "Location access denied. Please search for a city."
            return
        }
        
        do {
            let (lat, lon) = try await locationService.getCurrentLocation()
            await fetchWeather(lat: lat, lon: lon)
        } catch {
            errorMessage = "Unable to get location: \(error.localizedDescription)"
        }
    }
    
    private func updateUI(with response: WeatherResponse, city: String) {
        weather = response
        userDefaults.set(city, forKey: "lastCity")
        
        if let iconCode = response.weather.first?.icon {
            iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            // Preload cache
            Task {
                _ = try? await weatherService.loadIcon(iconCode: iconCode)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "No internet connection."
            default:
                errorMessage = "Network error. Please try again."
            }
        } else {
            // OpenWeatherMap Error (e.g., city not found)
            errorMessage = error.localizedDescription.capitalized
        }
    }
}
