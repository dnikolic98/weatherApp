//
//  ForecastCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension ForecastCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastCD> {
        return NSFetchRequest<ForecastCD>(entityName: "ForecastCD")
    }

    @NSManaged public var feelsLikeTemperature: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var maxTemperature: Double
    @NSManaged public var minTemperature: Double
    @NSManaged public var pressure: Int64
    @NSManaged public var temperature: Double
    @NSManaged public var currentWeather: CurrentWeatherCD

}
