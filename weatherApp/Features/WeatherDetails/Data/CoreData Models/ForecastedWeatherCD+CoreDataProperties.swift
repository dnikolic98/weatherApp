//
//  ForecastedWeatherCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension ForecastedWeatherCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastedWeatherCD> {
        return NSFetchRequest<ForecastedWeatherCD>(entityName: "ForecastedWeatherCD")
    }

    @NSManaged public var forecastedWeather: NSSet?

}

// MARK: Generated accessors for forecastedWeather
extension ForecastedWeatherCD {

    @objc(addForecastedWeatherObject:)
    @NSManaged public func addToForecastedWeather(_ value: DailyWeatherCD)

    @objc(removeForecastedWeatherObject:)
    @NSManaged public func removeFromForecastedWeather(_ value: DailyWeatherCD)

    @objc(addForecastedWeather:)
    @NSManaged public func addToForecastedWeather(_ values: NSSet)

    @objc(removeForecastedWeather:)
    @NSManaged public func removeFromForecastedWeather(_ values: NSSet)

}
