//
//  HourlyWeatherCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 24/09/2020.
//
//

import Foundation
import CoreData


extension HourlyWeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourlyWeatherCoreData> {
        return NSFetchRequest<HourlyWeatherCoreData>(entityName: "HourlyWeatherCoreData")
    }

    @NSManaged public var temperature: Double
    @NSManaged public var id: Int64
    @NSManaged public var updatedTime: Date
    @NSManaged public var forecastTime: Int64
    @NSManaged public var pressure: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var weather: WeatherCoreData
    @NSManaged public var forecastedWeather: ForecastedWeatherCoreData?

}
