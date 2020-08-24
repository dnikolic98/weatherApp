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
    
    func populate(weather: Weather, currentWeather: CurrentWeatherCD) {
        self.currentWeather = currentWeather
        self.populate(weather: weather)
    }
    
    //MARK: - DailyWeather
    
    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCD, context: NSManagedObjectContext) -> WeatherCD? {
        let predicate = NSPredicate(format: "dailyWeather = %@", dailyWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(weather: Weather, dailyWeather: DailyWeatherCD) {
        self.dailyWeather = dailyWeather
        self.populate(weather: weather)
    }
    
    //MARK: - Common
    
    private func populate(weather: Weather) {
        self.icon = weather.icon
        self.iconsUrlString = weather.iconUrlString
        self.overview = weather.overview
    }
    
}
