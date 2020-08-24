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
    
    func populate(forecastedWeather: ForecastedWeather, dailyWeathers: [DailyWeatherCD]) {
        self.longitude = forecastedWeather.longitude
        self.latitude = forecastedWeather.latitude
        for dailyWeather in dailyWeathers {
            self.addToForecastedWeather(dailyWeather)
        }
    }
    
}
