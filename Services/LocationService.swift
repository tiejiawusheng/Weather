//
//  LocationService.swift
//  Weather
//
//  Created by Wenbo Ma on 12/14/25.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func requestPermission() async -> Bool
    func getCurrentLocation() async throws -> (lat: Double, lon: Double)
}

actor LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var permissionContinuation: CheckedContinuation<Bool, Never>?
    private var locationContinuation: CheckedContinuation<(Double, Double), Error>?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestPermission() async -> Bool {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            return true
        }
        if status == .denied || status == .restricted {
            return false
        }
        
        manager.requestWhenInUseAuthorization()
        return await withCheckedContinuation { cont in
            permissionContinuation = cont
        }
    }
    
    func getCurrentLocation() async throws -> (lat: Double, lon: Double) {
        manager.requestLocation()
        return try await withCheckedThrowingContinuation { cont in
            locationContinuation = cont
        }
    }
    
    @nonobjc func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) async {
        let granted = manager.authorizationStatus == .authorizedWhenInUse ||
                      manager.authorizationStatus == .authorizedAlways
        permissionContinuation?.resume(returning: granted)
        permissionContinuation = nil
    }
    
    @nonobjc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) async {
        if let loc = locations.last {
            locationContinuation?.resume(returning: (loc.coordinate.latitude, loc.coordinate.longitude))
        } else {
            locationContinuation?.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location"]))
        }
        locationContinuation = nil
    }
    
    @nonobjc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) async {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
