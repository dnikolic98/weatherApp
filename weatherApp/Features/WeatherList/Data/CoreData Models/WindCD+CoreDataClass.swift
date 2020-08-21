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
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD) -> WindCD? {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<WindCD> = WindCD.fetchRequest()
        request.predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        request.returnsObjectsAsFaults = false
        
        do {
            let windFetched = try context.fetch(request)
            
            guard let wind = windFetched.first else {
                let newWind = WindCD(context: context)
                return newWind
            }
            
            return wind
        } catch {
            return nil
        }
    }
    
    class func createFrom(wind: Wind, currentWeather: CurrentWeatherCD) -> WindCD? {
        guard let windCD = firstOrCreate(withCurrentWeather: currentWeather) else { return nil }
        
        windCD.currentWeather = currentWeather
        windCD.directionDegree = Int64(wind.directionDegree)
        windCD.speed = wind.speed
        
        return windCD
    }
    
}
