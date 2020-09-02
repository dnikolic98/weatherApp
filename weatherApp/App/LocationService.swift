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

class LocationService {

    private (set) var location: Observable<Coordinates>

    private let locationManager = CLLocationManager()
    
    init() {
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        location = locationManager.rx
            .didUpdateLocations
            .filter { $1.count > 0 }
            .map {
                let coord = $1.last!.coordinate
                return Coordinates(latitude: coord.latitude, longitude: coord.longitude)
            }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

}
