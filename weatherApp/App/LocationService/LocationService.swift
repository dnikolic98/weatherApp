//
//  LocationService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreLocation

class LocationService: NSObject, LocationServiceProtocol {

    private var locationManager: CLLocationManager!
    private var completion: LocationServiceCompletion!

    func getLocation(completion: @escaping LocationServiceCompletion) {
        self.completion = completion
        
        startLocationService()
    }

    private func startLocationService() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func locationToCoordinates(location: CLLocation) -> Coordinates {
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            return Coordinates(latitude: lat, longitude: lon)
        }

}
