//
//  WeatherDisplayView.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import SwiftUI

struct WeatherDisplayView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading weather...")
                    .accessibilityLabel("Loading weather data")
            } else if let weather = viewModel.weather {
                VStack(spacing: 16) {
                    AsyncImage(url: viewModel.iconURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.red)
                        default:
                            ProgressView()
                                .frame(width: 120, height: 120)
                        }
                    }
                    .accessibilityHidden(true)
                    
                    Text(weather.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("\(Int(weather.main.temp))°F")
                        .font(.system(size: 72))
                        .fontWeight(.thin)
                    
                    Text(weather.weather.first?.description.capitalized ?? "")
                        .font(.title2)
                    
                    VStack(spacing: 8) {
                        Label("Feels like \(Int(weather.main.feelsLike))°F", systemImage: "thermometer")
                        Label("Humidity: \(weather.main.humidity)%", systemImage: "drop")
                        Label("Wind: \(Int(weather.wind.speed)) mph", systemImage: "wind")
                    }
                    .font(.title3)
                    .foregroundColor(.secondary)
                }
                .accessibilityElement(children: .combine)
            } else {
                Text("Enter a city above or allow location access for current weather")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .adaptToSizeClasses()
    }
}

// Adaptive landscape and portrait modes and size categories
extension View {
    func adaptToSizeClasses() -> some View {
        self.modifier(SizeClassAdaptiveModifier())
    }
}

struct SizeClassAdaptiveModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    func body(content: Content) -> some View {
        if horizontalSizeClass == .compact {
            content.padding()
        } else {
            content.padding(.horizontal, 100)
        }
    }
}
