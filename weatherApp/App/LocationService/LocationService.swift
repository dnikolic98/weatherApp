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
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

}
