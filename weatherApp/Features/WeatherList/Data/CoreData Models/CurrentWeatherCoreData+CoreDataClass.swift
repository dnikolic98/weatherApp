//
//  CurrentWeatherCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

@objc(CurrentWeatherCoreData)
public class CurrentWeatherCoreData: NSManagedObject {
    
    class func firstOrCreate(withId id: Int, context: NSManagedObjectContext) -> CurrentWeatherCoreData? {
        let predicate = NSPredicate(format: "id = %d", id)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(currentWeather: CurrentWeather, forecast: ForecastCoreData, weather: WeatherCoreData, coord: CoordinatesCoreData, wind: WindCoreData) {
        self.coord = coord
        self.forecast = forecast
        self.weather = weather
        self.wind = wind
        self.name = currentWeather.name
        self.id = Int64(currentWeather.id)
    }
    
}
