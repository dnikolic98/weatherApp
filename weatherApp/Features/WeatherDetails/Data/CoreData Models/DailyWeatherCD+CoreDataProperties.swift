//
//  DailyWeatherCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension DailyWeatherCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherCD> {
        return NSFetchRequest<DailyWeatherCD>(entityName: "DailyWeatherCD")
    }

    @NSManaged public var forecastTime: Int64
    @NSManaged public var humidity: Int64
    @NSManaged public var pressure: Double
    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64
    @NSManaged public var temperature: DailyTemperatureCD
    @NSManaged public var weather: WeatherCD
    @NSManaged public var forecastedWeather: ForecastedWeatherCD

}
