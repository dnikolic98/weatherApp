//
//  WeatherCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(WeatherCD)
public class WeatherCD: NSManagedObject {
    
    //MARK: - CurrentWeather
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> WeatherCD? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(weather: Weather, currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) -> WeatherCD? {
        guard let weatherCD = firstOrCreate(withCurrentWeather: currentWeather, context: context) else { return nil }
        
        weatherCD.currentWeather = currentWeather
        weatherCD.populate(weather: weather)
        
        return weatherCD
    }
    
    //MARK: - DailyWeather
    
    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCD, context: NSManagedObjectContext) -> WeatherCD? {
        let predicate = NSPredicate(format: "dailyWeather = %@", dailyWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    class func createFrom(weather: Weather, dailyWeather: DailyWeatherCD, context: NSManagedObjectContext) -> WeatherCD? {
        guard let weatherCD = firstOrCreate(withDailyWeather: dailyWeather, context: context) else { return nil }
        
        weatherCD.dailyWeather = dailyWeather
        weatherCD.populate(weather: weather)
        
        return weatherCD
    }
    
    
    func populate( weather: Weather) {
        self.icon = weather.icon
        self.iconsUrlString = weather.iconUrlString
        self.overview = weather.overview
    }
    
}
