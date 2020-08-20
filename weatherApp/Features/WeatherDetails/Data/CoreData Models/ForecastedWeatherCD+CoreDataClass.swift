//
//  ForecastedWeatherCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(ForecastedWeatherCD)
public class ForecastedWeatherCD: NSManagedObject {
    
    class func firstOrCreate(withLongitude lon: Double, withLatitude lat: Double) -> ForecastedWeatherCD? {
        let context = CoreData.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<ForecastedWeatherCD> = ForecastedWeatherCD.fetchRequest()
        let epsilon = 0.00001
        request.predicate = NSPredicate(format: "longitude > %f AND longitude < %f AND latitude > %f AND latitude < %f", lon-epsilon, lon+epsilon, lat-epsilon, lat+epsilon)
        request.returnsObjectsAsFaults = false
        
        do {
            let forecastedWeatherFetched = try context.fetch(request)
            
            guard let forecastedWeather = forecastedWeatherFetched.first else {
                let newForecastedWeather = ForecastedWeatherCD(context: context)
                return newForecastedWeather
            }
            
            return forecastedWeather
        } catch {
            return nil
        }
    }
    
    class func createFrom(forecastedWeather: ForecastedWeather) -> ForecastedWeatherCD? {
        guard
            let forecastedWeatherCD = firstOrCreate(withLongitude: forecastedWeather.longitude, withLatitude: forecastedWeather.latitude)
        else {
            return nil
        }
        
        forecastedWeatherCD.longitude = forecastedWeather.longitude
        forecastedWeatherCD.latitude = forecastedWeather.latitude
        for (index, dailyWeather) in forecastedWeather.forecastedWeather.enumerated() {
            if let dailyWeatherCD = DailyWeatherCD.createFrom(dailyWeather: dailyWeather, indexId: index, forecastedWeather: forecastedWeatherCD) {
//                forecastedWeatherCD.removeFromForecastedWeather(dailyWeatherCD)
                forecastedWeatherCD.addToForecastedWeather(dailyWeatherCD)
            }
        }
        
        do {
            let context = CoreData.shared.persistentContainer.viewContext
            try context.save()
            return forecastedWeatherCD
        } catch {
            print("Failed saving")
            return nil
        }
    }
    
}
