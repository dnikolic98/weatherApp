//
//  ForecastedWeatherCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(ForecastedWeatherCD)
public class ForecastedWeatherCD: NSManagedObject {
    
    class func firstOrCreate(withLongitude lon: Double, withLatitude lat: Double, context: NSManagedObjectContext) -> ForecastedWeatherCD? {
        let epsilon = 0.00001
        let format = "longitude > %f AND longitude < %f AND latitude > %f AND latitude < %f"
        let predicate = NSPredicate(format: format, lon-epsilon, lon+epsilon, lat-epsilon, lat+epsilon)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(forecastedWeather: ForecastedWeather, context: NSManagedObjectContext) -> ForecastedWeatherCD? {
        guard
            let forecastedWeatherCD = firstOrCreate(withLongitude: forecastedWeather.longitude, withLatitude: forecastedWeather.latitude, context: context)
        else {
            return nil
        }
        
        forecastedWeatherCD.longitude = forecastedWeather.longitude
        forecastedWeatherCD.latitude = forecastedWeather.latitude
        for (index, dailyWeather) in forecastedWeather.forecastedWeather.enumerated() {
            if let dailyWeatherCD = DailyWeatherCD.createFrom(dailyWeather: dailyWeather, indexId: index, forecastedWeather: forecastedWeatherCD, context: context) {
                forecastedWeatherCD.addToForecastedWeather(dailyWeatherCD)
            }
        }
        return forecastedWeatherCD
    }
    
}
