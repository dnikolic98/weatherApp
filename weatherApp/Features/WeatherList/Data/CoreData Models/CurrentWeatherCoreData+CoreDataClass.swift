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
        let predicate = Predicates.idPredicate(id)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(currentWeather: CurrentWeather, forecast: ForecastCoreData, weather: WeatherCoreData, coord: CoordinatesCoreData, wind: WindCoreData) {
        self.coord = coord
        self.forecast = forecast
        self.weather = weather
        self.wind = wind
        self.name = currentWeather.name
        self.id = Int64(currentWeather.id)
        self.updatedTime = Date()
        self.dayTime = Int64(currentWeather.dayTime)
        self.sunset = Int64(currentWeather.timeInfo.sunset)
        self.sunrise = Int64(currentWeather.timeInfo.sunrise)
    }
    
}
