//
//  DailyTemperatureCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(DailyTemperatureCoreData)
public class DailyTemperatureCoreData: NSManagedObject {

    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCoreData, context: NSManagedObjectContext) -> DailyTemperatureCoreData? {
        let predicate = Predicates.dailyWeatherPredicate(dailyWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCoreData) {
        self.dailyWeather = dailyWeather
        self.day = dailyTemperature.day
        self.evening = dailyTemperature.evening
        self.morning = dailyTemperature.morning
        self.max = dailyTemperature.max
        self.min = dailyTemperature.min
        self.night = dailyTemperature.night
    }
    
}
