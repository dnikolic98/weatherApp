//
//  DailyTemperatureCD+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(DailyTemperatureCD)
public class DailyTemperatureCD: NSManagedObject {

    class func firstOrCreate(withDailyWeather dailyWeather: DailyWeatherCD) -> DailyTemperatureCD? {
        let context = CoreData.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<DailyTemperatureCD> = DailyTemperatureCD.fetchRequest()
        request.predicate = NSPredicate(format: "dailyWeather = %@", dailyWeather)
        request.returnsObjectsAsFaults = false
        
        do {
            let temperatureFetched = try context.fetch(request)
            
            guard let temperature = temperatureFetched.first else {
                let newTemperature = DailyTemperatureCD(context: context)
                return newTemperature
            }
            
            return temperature
        } catch {
            return nil
        }
    }
    
    class func createFrom(weather: Weather, currentWeather: CurrentWeatherCD) -> DailyTemperatureCD? {
        guard let weatherCD = firstOrCreate(withCurrentWeather: currentWeather) else { return nil }
        
        weatherCD.currentWeather = currentWeather
        weatherCD.icon = weather.icon
        weatherCD.iconsUrlString = weather.iconUrlString
        weatherCD.overview = weather.overview
        
        do {
            let context = CoreData.shared.persistentContainer.viewContext
            try context.save()
            return weatherCD
        } catch {
            print("Failed saving")
            return nil
        }
    }
    
}
