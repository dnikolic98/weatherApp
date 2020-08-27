//
//  DailyWeatherCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(DailyWeatherCoreData)
public class DailyWeatherCoreData: NSManagedObject {
    
    class func firstOrCreate(withForecastedWeather forecastedWeather: ForecastedWeatherCoreData, withId id: Int, context: NSManagedObjectContext) -> DailyWeatherCoreData? {
        let predicate = NSPredicate(format: "id = %d AND forecastedWeather = %@", id, forecastedWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCoreData, temperature: DailyTemperatureCoreData, weather: WeatherCoreData) {
        self.forecastedWeather = forecastedWeather
        self.id = Int64(indexId)
        self.weather = weather
        self.forecastTime = Int64(dailyWeather.forecastTime)
        self.humidity = Int64(dailyWeather.humidity)
        self.pressure = dailyWeather.pressure
        self.sunrise = Int64(dailyWeather.sunrise)
        self.sunset = Int64(dailyWeather.sunset)
        self.temperature = temperature
    }
    
}
