//
//  HourlyWeatherCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 24/09/2020.
//
//

import Foundation
import CoreData

@objc(HourlyWeatherCoreData)
public class HourlyWeatherCoreData: NSManagedObject {
    
    class func firstOrCreate(withForecastedWeather forecastedWeather: ForecastedWeatherCoreData, withId id: Int, context: NSManagedObjectContext) -> HourlyWeatherCoreData? {
        let predicate = Predicates.idPredicate(id).and(Predicates.forecastedWeatherPredicate(forecastedWeather))
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(hourlyWeather: HourlyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCoreData, weather: WeatherCoreData) {
        self.forecastedWeather = forecastedWeather
        self.id = Int64(indexId)
        self.weather = weather
        self.forecastTime = Int64(hourlyWeather.forecastTime)
        self.humidity = Int64(hourlyWeather.humidity)
        self.pressure = hourlyWeather.pressure
        self.temperature = hourlyWeather.temperature
        self.updatedTime = Date()
    }
    
}
