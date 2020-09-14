//
//  LocationService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCoreLocation

class LocationService: LocationServiceProtocol {
    
    private (set) var isEnabled: Observable<Bool>
    private (set) var location: Observable<Coordinates>

    private let locationManager = CLLocationManager()
    
    init() {
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        location = locationManager.rx
            .didUpdateLocations
            .filter { !$1.isEmpty }
            .map { locationManager, locations in
                guard let coord = locations.last?.coordinate else { return Coordinates(latitude: 0, longitude: 0) }
                return Coordinates(latitude: coord.latitude, longitude: coord.longitude)
            }
        
        isEnabled = Observable
            .combineLatest(locationManager.rx.isEnabled,
                           locationManager.rx.didChangeAuthorization)
            .flatMap { enabled, _  -> Observable<Bool> in
                .just(enabled)
            }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func checkLocationServicesAuthorization() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                break
            }
        }
        
        return false
    }
    
}
