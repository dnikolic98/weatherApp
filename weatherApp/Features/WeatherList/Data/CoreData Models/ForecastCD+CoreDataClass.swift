//
//  ForecastCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(ForecastCD)
public class ForecastCD: NSManagedObject {
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> ForecastCD? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(forecast: Forecast, currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> ForecastCD? {
        guard let forecastCD = firstOrCreate(withCurrentWeather: currentWeather, context: context) else { return nil }
        
        forecastCD.currentWeather = currentWeather
        forecastCD.feelsLikeTemperature = forecast.feelsLikeTemperature
        forecastCD.humidity = Int64(forecast.humidity)
        forecastCD.pressure = Int64(forecast.pressure)
        forecastCD.maxTemperature = forecast.maxTemperature
        forecastCD.minTemperature = forecast.minTemperature
        forecastCD.temperature = forecast.temperature
        
        return forecastCD
    }
    
}
