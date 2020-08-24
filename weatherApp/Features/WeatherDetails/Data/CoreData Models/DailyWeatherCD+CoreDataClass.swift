//
//  DailyWeatherCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(DailyWeatherCD)
public class DailyWeatherCD: NSManagedObject {
    
    class func firstOrCreate(withForecastedWeather forecastedWeather: ForecastedWeatherCD, withId id: Int, context: NSManagedObjectContext) -> DailyWeatherCD? {
        let predicate = NSPredicate(format: "id = %d AND forecastedWeather = %@", id, forecastedWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCD, context: NSManagedObjectContext) -> DailyWeatherCD? {
        guard
            let dailyWeatherCD = firstOrCreate(withForecastedWeather: forecastedWeather, withId: indexId, context: context),
            let weather = dailyWeather.weather.at(0),
            let temperatureCD = DailyTemperatureCD.createFrom(dailyTemperature: dailyWeather.temperature, dailyWeather: dailyWeatherCD, context: context),
            let weatherCD = WeatherCD.createFrom(weather: weather, dailyWeather: dailyWeatherCD, context: context)
        else {
            return nil
        }
        
        dailyWeatherCD.forecastedWeather = forecastedWeather
        dailyWeatherCD.id = Int64(indexId)
        dailyWeatherCD.weather = weatherCD
        dailyWeatherCD.forecastTime = Int64(dailyWeather.forecastTime)
        dailyWeatherCD.humidity = Int64(dailyWeather.humidity)
        dailyWeatherCD.pressure = dailyWeather.pressure
        dailyWeatherCD.sunrise = Int64(dailyWeather.sunrise)
        dailyWeatherCD.sunset = Int64(dailyWeather.sunset)
        dailyWeatherCD.temperature = temperatureCD
        
        return dailyWeatherCD
    }
    
}
