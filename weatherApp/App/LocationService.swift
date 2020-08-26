//
//  LocationService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreLocation

class LocationService: NSObject {

    public typealias LocationServiceCompletion = (Coordinates?, Error?) -> (Void)

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

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation
        let coord = locationToCoordinates(location: location)
        
        completion(coord, nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion(nil, error)
    }
}
