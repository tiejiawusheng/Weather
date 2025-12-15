//
//  ContentView.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    @State private var cityInput: String = ""
    
    var body: some View {
        Group {
            if let viewModel = coordinator.viewModel {
                WeatherMainView(viewModel: viewModel, cityInput: $cityInput)
            } else {
                ProgressView("Initializing app...")
                    .progressViewStyle(.circular)
            }
        }
    }
}

struct WeatherMainView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Binding var cityInput: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 搜索栏
                HStack {
                    TextField("Enter US city", text: $cityInput)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.words)
                        .onSubmit {
                            searchCity()
                        }
                    
                    Button("Search") {
                        searchCity()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
                // Weather display
                WeatherDisplayView(viewModel: viewModel)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Weather")
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                // Restore the last city.
                if let lastCity = viewModel.lastSearchedCity, cityInput.isEmpty {
                    cityInput = lastCity
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private func searchCity() {
        let trimmed = cityInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        Task {
            await viewModel.fetchWeather(for: trimmed)
        }
    }
}
