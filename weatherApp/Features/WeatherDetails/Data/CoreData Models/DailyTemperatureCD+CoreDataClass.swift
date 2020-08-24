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

    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCD, context: NSManagedObjectContext) -> DailyTemperatureCD? {
        let predicate = NSPredicate(format: "dailyWeather = %@", dailyWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCD, context: NSManagedObjectContext) -> DailyTemperatureCD? {
        guard let dailyTemperatureCD = firstOrCreate(withDailyWeather: dailyWeather, context: context) else { return nil }
        
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
