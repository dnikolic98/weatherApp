//
//  ForecastedWeatherCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension ForecastedWeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastedWeatherCoreData> {
        return NSFetchRequest<ForecastedWeatherCoreData>(entityName: "ForecastedWeatherCoreData")
    }
    
    @NSManaged public var forecastedWeather: NSSet
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

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
