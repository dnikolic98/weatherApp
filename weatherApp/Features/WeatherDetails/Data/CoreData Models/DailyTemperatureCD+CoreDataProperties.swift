//
//  DailyTemperatureCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension DailyTemperatureCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTemperatureCD> {
        return NSFetchRequest<DailyTemperatureCD>(entityName: "DailyTemperatureCD")
    }

    @NSManaged public var day: Double
    @NSManaged public var evening: Double
    @NSManaged public var max: Double
    @NSManaged public var min: Double
    @NSManaged public var morning: Double
    @NSManaged public var night: Double
    @NSManaged public var dailyWeather: DailyWeatherCD

}
