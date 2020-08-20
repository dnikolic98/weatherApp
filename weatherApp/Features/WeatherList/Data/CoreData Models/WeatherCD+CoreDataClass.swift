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
        let context = CoreData.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<WeatherCD> = WeatherCD.fetchRequest()
        request.predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
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
    
    class func createFrom(weather: Weather, currentWeather: CurrentWeatherCD) -> WeatherCD? {
        guard let weatherCD = firstOrCreate(withCurrentWeather: currentWeather) else { return nil }
        
        weatherCD.currentWeather = currentWeather
        weatherCD.icon = weather.icon
        weatherCD.iconsUrlString = weather.iconUrlString
        weatherCD.overview = weather.overview
        
        
            return weatherCD
    }
    
    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCD) -> WeatherCD? {
        let context = CoreData.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<WeatherCD> = WeatherCD.fetchRequest()
        request.predicate = NSPredicate(format: "dailyWeather = %@", dailyWeather)
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
    
    class func createFrom(weather: Weather, dailyWeather: DailyWeatherCD) -> WeatherCD? {
        guard let weatherCD = firstOrCreate(withDailyWeather: dailyWeather) else { return nil }
        
        weatherCD.dailyWeather = dailyWeather
        weatherCD.icon = weather.icon
        weatherCD.iconsUrlString = weather.iconUrlString
        weatherCD.overview = weather.overview
        
        return weatherCD
    }
    
}
