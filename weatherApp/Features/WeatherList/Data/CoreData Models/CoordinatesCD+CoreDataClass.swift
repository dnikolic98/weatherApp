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
    
    class func createFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> CoordinatesCD? {
        guard let coordinatesCD = firstOrCreate(withCurrentWeather: currentWeather, context: context) else { return nil }
        
        coordinatesCD.currentWeather = currentWeather
        coordinatesCD.latitude = coordinates.latitude
        coordinatesCD.longitude = coordinates.longitude
        
        return coordinatesCD
    }
    
}
