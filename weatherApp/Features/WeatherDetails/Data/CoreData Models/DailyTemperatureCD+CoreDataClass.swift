//
//  DailyTemperatureCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(DailyTemperatureCD)
public class DailyTemperatureCD: NSManagedObject {

    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCD) -> DailyTemperatureCD? {
        let context = CoreData.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<DailyTemperatureCD> = DailyTemperatureCD.fetchRequest()
        request.predicate = NSPredicate(format: "dailyWeather = %@", dailyWeather)
        request.returnsObjectsAsFaults = false
        
        do {
            let temperatureFetched = try context.fetch(request)
            
            guard let temperature = temperatureFetched.first else {
                let newTemperature = DailyTemperatureCD(context: context)
                return newTemperature
            }
            
            return temperature
        } catch {
            return nil
        }
    }
    
    class func createFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCD) -> DailyTemperatureCD? {
        guard let dailyTemperatureCD = firstOrCreate(withDailyWeather: dailyWeather) else { return nil }
        
        dailyTemperatureCD.dailyWeather = dailyWeather
        dailyTemperatureCD.day = dailyTemperature.day
        dailyTemperatureCD.evening = dailyTemperature.evening
        dailyTemperatureCD.morning = dailyTemperature.morning
        dailyTemperatureCD.max = dailyTemperature.max
        dailyTemperatureCD.min = dailyTemperature.min
        dailyTemperatureCD.night = dailyTemperature.night
        
        return dailyTemperatureCD
    }
    
}
