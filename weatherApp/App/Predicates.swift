//
//  Predicates.swift
//  weatherApp
//
//  Created by Dario Nikolic on 27/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

class Predicates {
    
    class func coordinatesPredicate(latitude lat: Double, longitude lon: Double, epsilon: Double = 0.00001, keyPath: String = "") -> NSPredicate {
        let keyPath = keyPath.isEmpty ? keyPath : keyPath + "."
        
        let format = "\(keyPath)longitude > %f AND \(keyPath)longitude < %f AND \(keyPath)latitude > %f AND \(keyPath)latitude < %f"
        return NSPredicate(format: format, lon - epsilon, lon + epsilon, lat - epsilon, lat + epsilon)
    }
    
    class func coordinatesPredicate(_ coordinates: Coordinates, epsilon: Double = 0.00001, keyPath: String = "") -> NSPredicate  {
        let lon = coordinates.longitude
        let lat = coordinates.latitude
        
        return coordinatesPredicate(latitude: lat, longitude: lon, epsilon: epsilon, keyPath: keyPath)
    }
    
    class func idPredicate(_ id: Int) -> NSPredicate {
        return NSPredicate(format: "id = %d", id)
    }
    
    class func currentWeatherPredicate(_ currentWeather: CurrentWeatherCoreData)  -> NSPredicate {
        return NSPredicate(format: "currentWeather = %@", currentWeather)
    }
    
    class func dailyWeatherPredicate(_ dailyWeather: DailyWeatherCoreData)  -> NSPredicate {
        return NSPredicate(format: "dailyWeather = %@", dailyWeather)
    }
    
    class func forecastedWeatherPredicate(_ forecastedWeather: ForecastedWeatherCoreData) -> NSPredicate {
        return NSPredicate(format: "forecastedWeather = %@", forecastedWeather)
    }
    
    class func severalIdPredicate(_ ids: [Int]) -> NSPredicate {
        return NSPredicate(format: "id IN %@", ids)
    }
    
    class func beginsWithNamePredicate(_ name: String) -> NSPredicate {
        return NSPredicate(format: "name BEGINSWITH[cd] %@", name)
    }
    
}
