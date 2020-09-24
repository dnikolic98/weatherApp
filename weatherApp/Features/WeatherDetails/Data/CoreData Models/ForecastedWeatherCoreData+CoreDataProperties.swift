//
//  ForecastedWeatherCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 24/09/2020.
//
//

import Foundation
import CoreData

extension ForecastedWeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastedWeatherCoreData> {
        return NSFetchRequest<ForecastedWeatherCoreData>(entityName: "ForecastedWeatherCoreData")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var forecastedWeather: NSSet
    @NSManaged public var hourlyWeather: NSSet

}

// MARK: Generated accessors for forecastedWeather
extension ForecastedWeatherCoreData {

    @objc(addForecastedWeatherObject:)
    @NSManaged public func addToForecastedWeather(_ value: DailyWeatherCoreData)

    @objc(removeForecastedWeatherObject:)
    @NSManaged public func removeFromForecastedWeather(_ value: DailyWeatherCoreData)

    @objc(addForecastedWeather:)
    @NSManaged public func addToForecastedWeather(_ values: NSSet)

    @objc(removeForecastedWeather:)
    @NSManaged public func removeFromForecastedWeather(_ values: NSSet)

}

// MARK: Generated accessors for hourlyWeather
extension ForecastedWeatherCoreData {

    @objc(addHourlyWeatherObject:)
    @NSManaged public func addToHourlyWeather(_ value: HourlyWeatherCoreData)

    @objc(removeHourlyWeatherObject:)
    @NSManaged public func removeFromHourlyWeather(_ value: HourlyWeatherCoreData)

    @objc(addHourlyWeather:)
    @NSManaged public func addToHourlyWeather(_ values: NSSet)

    @objc(removeHourlyWeather:)
    @NSManaged public func removeFromHourlyWeather(_ values: NSSet)

}
