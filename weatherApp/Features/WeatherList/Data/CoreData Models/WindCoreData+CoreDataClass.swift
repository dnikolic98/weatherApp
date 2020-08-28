//
//  WindCCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(WindCoreData)
public class WindCoreData: NSManagedObject {
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCoreData, context: NSManagedObjectContext) -> WindCoreData? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(wind: Wind, currentWeather: CurrentWeatherCoreData) {
        self.currentWeather = currentWeather
        self.directionDegree = Int64(wind.directionDegree)
        self.speed = wind.speed
    }
    
}
