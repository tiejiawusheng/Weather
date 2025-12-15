//
//  WeatherApp.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator) 
                .onAppear {
                    coordinator.start()
                }
        }
    }
}
