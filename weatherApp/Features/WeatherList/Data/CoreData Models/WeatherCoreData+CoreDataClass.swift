//
//  WeatherCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(WeatherCoreData)
public class WeatherCoreData: NSManagedObject {
    
    //MARK: - CurrentWeather
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCoreData, context: NSManagedObjectContext) -> WeatherCoreData? {
        let predicate = Predicates.currentWeatherPredicate(currentWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(weather: Weather, currentWeather: CurrentWeatherCoreData) {
        self.currentWeather = currentWeather
        self.populate(weather: weather)
    }
    
    //MARK: - DailyWeather
    
    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCoreData, context: NSManagedObjectContext) -> WeatherCoreData? {
        let predicate = Predicates.dailyWeatherPredicate(dailyWeather)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(weather: Weather, dailyWeather: DailyWeatherCoreData) {
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
