//
//  CoordinatesCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(CoordinatesCD)
public class CoordinatesCD: NSManagedObject {
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> CoordinatesCD? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(coordinates: Coordinates, currentWeather: CurrentWeatherCD) {
        self.currentWeather = currentWeather
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
    }
    
}
