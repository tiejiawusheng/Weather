//
//  AppCoordinator.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import Foundation
import Combine

class AppCoordinator: ObservableObject {
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    private let userDefaults = UserDefaults.standard
    
    
    @Published var viewModel: WeatherViewModel?
    
    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        locationService: LocationServiceProtocol = LocationService()
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.viewModel = nil  
    }
    
    func start() {
        let vm = WeatherViewModel(
            weatherService: weatherService,
            locationService: locationService,
            userDefaults: userDefaults
        )
        self.viewModel = vm
    }
}
