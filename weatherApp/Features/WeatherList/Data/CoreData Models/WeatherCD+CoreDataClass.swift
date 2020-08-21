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
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD) -> WeatherCD? {
        let predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        return firstOrCreate(withPredicate: predicate)
    }
    
    class func createFrom(weather: Weather, currentWeather: CurrentWeatherCD) -> WeatherCD? {
        guard let weatherCD = firstOrCreate(withCurrentWeather: currentWeather) else { return nil }
        
        weatherCD.currentWeather = currentWeather
        populate(weatherCoreData: weatherCD, weather: weather)
        
        return weatherCD
    }
    
    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCD) -> WeatherCD? {
        let predicate = NSPredicate(format: "dailyWeather = %@", dailyWeather)
        return firstOrCreate(withPredicate: predicate)
    }
    
    class func createFrom(weather: Weather, dailyWeather: DailyWeatherCD) -> WeatherCD? {
        guard let weatherCD = firstOrCreate(withDailyWeather: dailyWeather) else { return nil }
        
        weatherCD.dailyWeather = dailyWeather
        populate(weatherCoreData: weatherCD, weather: weather)
        
        return weatherCD
    }
    
    private class func populate(weatherCoreData: WeatherCD, weather: Weather) {
        weatherCoreData.icon = weather.icon
        weatherCoreData.iconsUrlString = weather.iconUrlString
        weatherCoreData.overview = weather.overview
    }
    
    private class func firstOrCreate(withPredicate predicate: NSPredicate) -> WeatherCD? {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<WeatherCD> = WeatherCD.fetchRequest()
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let weatherFetched = try context.fetch(request)
            
            guard let weather = weatherFetched.first else {
                let newWeather = WeatherCD(context: context)
                return newWeather
            }
            
            return weather
        } catch {
            return nil
        }
    }
    
}
