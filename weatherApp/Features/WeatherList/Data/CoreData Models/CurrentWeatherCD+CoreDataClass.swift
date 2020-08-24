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
    
    class func firstOrCreate(withId id: Int, context: NSManagedObjectContext) -> CurrentWeatherCD? {
        let predicate = NSPredicate(format: "id = %d", id)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(currentWeather: CurrentWeather, forecast: ForecastCD, weather: WeatherCD, coord: CoordinatesCD, wind: WindCD) {
        self.coord = coord
        self.forecast = forecast
        self.weather = weather
        self.wind = wind
        self.name = currentWeather.name
        self.id = Int64(currentWeather.id)
    }
    
}
