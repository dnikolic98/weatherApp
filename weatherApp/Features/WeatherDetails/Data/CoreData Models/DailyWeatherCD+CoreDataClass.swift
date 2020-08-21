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
    
    class func firstOrCreate(withForecastedWeather forecastedWeather: ForecastedWeatherCD, withId id: Int) -> DailyWeatherCD? {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<DailyWeatherCD> = DailyWeatherCD.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d AND forecastedWeather = %@", id, forecastedWeather)
        request.returnsObjectsAsFaults = false
        
        do {
            let temperatureFetched = try context.fetch(request)
            
            guard let temperature = temperatureFetched.first else {
                let newTemperature = DailyWeatherCD(context: context)
                return newTemperature
            }
            
            return temperature
        } catch {
            return nil
        }
    }
    
    class func createFrom(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCD) -> DailyWeatherCD? {
        guard
            let dailyWeatherCD = firstOrCreate(withForecastedWeather: forecastedWeather, withId: indexId),
            let weather = dailyWeather.weather.at(0),
            let temperatureCD = DailyTemperatureCD.createFrom(dailyTemperature: dailyWeather.temperature, dailyWeather: dailyWeatherCD),
            let weatherCD = WeatherCD.createFrom(weather: weather, dailyWeather: dailyWeatherCD)
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
