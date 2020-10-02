//
//  CurrentWeatherCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension CurrentWeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherCoreData> {
        return NSFetchRequest<CurrentWeatherCoreData>(entityName: "CurrentWeatherCoreData")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var dayTime: Int64
    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64
    @NSManaged public var name: String
    @NSManaged public var updatedTime: Date
    @NSManaged public var coord: CoordinatesCoreData
    @NSManaged public var forecast: ForecastCoreData
    @NSManaged public var weather: WeatherCoreData
    @NSManaged public var wind: WindCoreData

}
