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
    
    class func firstOrCreate(withId id: Int) -> CurrentWeatherCD? {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<CurrentWeatherCD> = CurrentWeatherCD.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        
        do {
            let currentWeatherFetch = try context.fetch(request)
            
            guard let currentWeather = currentWeatherFetch.first else {
                let newCurrentWeather = CurrentWeatherCD(context: context)
                return newCurrentWeather
            }
            
            return currentWeather
        } catch {
            return nil
        }
    }
    
    class func createFrom(currentWeather: CurrentWeather) -> CurrentWeatherCD? {
        guard
            let currentWeatherCD = firstOrCreate(withId: currentWeather.id),
            let weather = currentWeather.weather.at(0),
            let weatherCD = WeatherCD.createFrom(weather: weather, currentWeather: currentWeatherCD),
            let coordCD = CoordinatesCD.createFrom(coordinates: currentWeather.coord, currentWeather: currentWeatherCD),
            let windCD = WindCD.createFrom(wind: currentWeather.wind, currentWeather: currentWeatherCD),
            let forecastCD = ForecastCD.createFrom(forecast: currentWeather.forecast, currentWeather: currentWeatherCD)
        else {
            return nil
        }
        
        currentWeatherCD.coord = coordCD
        currentWeatherCD.forecast = forecastCD
        currentWeatherCD.weather = weatherCD
        currentWeatherCD.wind = windCD
        currentWeatherCD.name = currentWeather.name
        currentWeatherCD.id = Int64(currentWeather.id)
        
        do {
            let context = CoreDataStack.shared.persistentContainer.viewContext
            try context.save()
            return currentWeatherCD
        } catch {
            print(error)
            return nil
        }
    }
    
}
