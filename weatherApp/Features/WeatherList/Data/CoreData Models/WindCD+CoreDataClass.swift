//
//  WindCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(WindCD)
public class WindCD: NSManagedObject {
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> WindCD? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(wind: Wind, currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> WindCD? {
        guard let windCD = firstOrCreate(withCurrentWeather: currentWeather, context: context) else { return nil }
        
        windCD.currentWeather = currentWeather
        windCD.directionDegree = Int64(wind.directionDegree)
        windCD.speed = wind.speed
        
        return windCD
    }
    
}
