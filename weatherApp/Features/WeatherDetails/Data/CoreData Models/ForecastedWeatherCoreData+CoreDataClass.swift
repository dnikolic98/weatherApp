//
//  ForecastedWeatherCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(ForecastedWeatherCoreData)
public class ForecastedWeatherCoreData: NSManagedObject {
    
    class func firstOrCreate(withLongitude lon: Double, withLatitude lat: Double, context: NSManagedObjectContext) -> ForecastedWeatherCoreData? {
        let predicate = Predicates.coordinatesPredicate(latitude: lat, longitude: lon)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(forecastedWeather: ForecastedWeather, dailyWeathers: [DailyWeatherCoreData], hourlyWeathers: [HourlyWeatherCoreData]) {
        self.longitude = forecastedWeather.longitude
        self.latitude = forecastedWeather.latitude
        for dailyWeather in dailyWeathers {
            self.addToForecastedWeather(dailyWeather)
        }
        for hourlyWeather in hourlyWeathers {
            self.addToHourlyWeather(hourlyWeather)
        }
    }
    
}
