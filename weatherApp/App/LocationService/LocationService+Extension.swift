//
//  LocationService+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 02/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreLocation

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
