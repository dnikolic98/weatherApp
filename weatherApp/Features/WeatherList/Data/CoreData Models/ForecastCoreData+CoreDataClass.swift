//
//  ForecastCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(ForecastCoreData)
public class ForecastCoreData: NSManagedObject {
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCoreData, context: NSManagedObjectContext) -> ForecastCoreData? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(forecast: Forecast, currentWeather: CurrentWeatherCoreData) {
        self.currentWeather = currentWeather
        self.feelsLikeTemperature = forecast.feelsLikeTemperature
        self.humidity = Int64(forecast.humidity)
        self.pressure = Int64(forecast.pressure)
        self.maxTemperature = forecast.maxTemperature
        self.minTemperature = forecast.minTemperature
        self.temperature = forecast.temperature
    }
    
}
