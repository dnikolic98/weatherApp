//
//  CoordinatesCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(CoordinatesCoreData)
public class CoordinatesCoreData: NSManagedObject {
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCoreData, context: NSManagedObjectContext) -> CoordinatesCoreData? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(coordinates: Coordinates, currentWeather: CurrentWeatherCoreData) {
        self.currentWeather = currentWeather
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
    }
    
}
