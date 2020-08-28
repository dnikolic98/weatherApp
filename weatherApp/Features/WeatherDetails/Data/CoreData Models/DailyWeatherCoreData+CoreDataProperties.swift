//
//  DailyWeatherCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension DailyWeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherCoreData> {
        return NSFetchRequest<DailyWeatherCoreData>(entityName: "DailyWeatherCoreData")
    }

    @NSManaged public var forecastTime: Int64
    @NSManaged public var humidity: Int64
    @NSManaged public var id: Int64
    @NSManaged public var pressure: Double
    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64
    @NSManaged public var temperature: DailyTemperatureCoreData
    @NSManaged public var weather: WeatherCoreData
    @NSManaged public var forecastedWeather: ForecastedWeatherCoreData

}
