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
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD) -> CoordinatesCD? {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<CoordinatesCD> = CoordinatesCD.fetchRequest()
        request.predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        request.returnsObjectsAsFaults = false
        
        do {
            let coordinatesFetched = try context.fetch(request)
            
            guard let coordinates = coordinatesFetched.first else {
                let newCoordinates = CoordinatesCD(context: context)
                return newCoordinates
            }
            return coordinates
        } catch {
            return nil
        }
    }
    
    class func createFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCD) -> CoordinatesCD? {
        guard let coordinatesCD = firstOrCreate(withCurrentWeather: currentWeather) else { return nil }
        
        coordinatesCD.currentWeather = currentWeather
        coordinatesCD.latitude = coordinates.latitude
        coordinatesCD.longitude = coordinates.longitude
        
        return coordinatesCD
    }
    
}
