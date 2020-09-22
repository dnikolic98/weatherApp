//
//  DailyTemperatureCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData

extension DailyTemperatureCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTemperatureCoreData> {
        return NSFetchRequest<DailyTemperatureCoreData>(entityName: "DailyTemperatureCoreData")
    }

    @NSManaged public var day: Double
    @NSManaged public var evening: Double
    @NSManaged public var max: Double
    @NSManaged public var min: Double
    @NSManaged public var morning: Double
    @NSManaged public var night: Double
    @NSManaged public var dailyWeather: DailyWeatherCoreData

}
