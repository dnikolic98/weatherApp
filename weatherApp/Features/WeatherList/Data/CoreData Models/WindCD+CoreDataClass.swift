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
    
    func populate(wind: Wind, currentWeather: CurrentWeatherCD) {
        self.currentWeather = currentWeather
        self.directionDegree = Int64(wind.directionDegree)
        self.speed = wind.speed
    }
    
}
