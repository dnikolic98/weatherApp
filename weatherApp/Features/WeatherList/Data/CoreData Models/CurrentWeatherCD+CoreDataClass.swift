//
//  CurrentWeatherCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(CurrentWeatherCD)
public class CurrentWeatherCD: NSManagedObject {
    
    class func firstOrCreate(withId id: Int, context: NSManagedObjectContext) -> CurrentWeatherCD? {
        let predicate = NSPredicate(format: "id = %d", id)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(currentWeather: CurrentWeather, context: NSManagedObjectContext) -> CurrentWeatherCD? {
        guard
            let currentWeatherCD = firstOrCreate(withId: currentWeather.id, context: context),
            let weather = currentWeather.weather.at(0),
            let weatherCD = WeatherCD.createFrom(weather: weather, currentWeather: currentWeatherCD, context: context),
            let coordCD = CoordinatesCD.createFrom(coordinates: currentWeather.coord, currentWeather: currentWeatherCD, context: context),
            let windCD = WindCD.createFrom(wind: currentWeather.wind, currentWeather: currentWeatherCD, context: context),
            let forecastCD = ForecastCD.createFrom(forecast: currentWeather.forecast, currentWeather: currentWeatherCD, context: context)
        else {
            return nil
        }
        
        currentWeatherCD.coord = coordCD
        currentWeatherCD.forecast = forecastCD
        currentWeatherCD.weather = weatherCD
        currentWeatherCD.wind = windCD
        currentWeatherCD.name = currentWeather.name
        currentWeatherCD.id = Int64(currentWeather.id)
        
        return currentWeatherCD
    }
    
}
