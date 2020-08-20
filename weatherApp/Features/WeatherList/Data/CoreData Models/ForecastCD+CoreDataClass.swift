//
//  ForecastCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(ForecastCD)
public class ForecastCD: NSManagedObject {
    
    class func firstOrCreate(withCurrentWeather currentWeather: CurrentWeatherCD) -> ForecastCD? {
        let context = CoreData.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<ForecastCD> = ForecastCD.fetchRequest()
        request.predicate = NSPredicate(format: "currentWeather = %@", currentWeather)
        request.returnsObjectsAsFaults = false
        
        do {
            let forecastFetched = try context.fetch(request)
            
            guard let forecast = forecastFetched.first else {
                let newForecast = ForecastCD(context: context)
                return newForecast
            }
            
            return forecast
        } catch {
            return nil
        }
    }
    
    class func createFrom(forecast: Forecast, currentWeather: CurrentWeatherCD) -> ForecastCD? {
        guard let forecastCD = firstOrCreate(withCurrentWeather: currentWeather) else { return nil }
        
        forecastCD.currentWeather = currentWeather
        forecastCD.feelsLikeTemperature = forecast.feelsLikeTemperature
        forecastCD.humidity = Int64(forecast.humidity)
        forecastCD.pressure = Int64(forecast.pressure)
        forecastCD.maxTemperature = forecast.maxTemperature
        forecastCD.minTemperature = forecast.minTemperature
        forecastCD.temperature = forecast.temperature
        
        
        return forecastCD
    }
    
}
