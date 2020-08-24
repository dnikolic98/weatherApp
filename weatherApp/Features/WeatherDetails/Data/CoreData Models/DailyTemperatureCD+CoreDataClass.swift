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
    
    func populate(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCD) {
        self.dailyWeather = dailyWeather
        self.day = dailyTemperature.day
        self.evening = dailyTemperature.evening
        self.morning = dailyTemperature.morning
        self.max = dailyTemperature.max
        self.min = dailyTemperature.min
        self.night = dailyTemperature.night
    }
    
}
