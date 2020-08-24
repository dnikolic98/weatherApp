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
    
    func populate(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCD, temperature: DailyTemperatureCD, weather: WeatherCD) {
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
