//
//  WeatherCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension WeatherCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCoreData> {
        return NSFetchRequest<WeatherCoreData>(entityName: "WeatherCoreData")
    }

    @NSManaged public var icon: String
    @NSManaged public var iconsUrlString: String
    @NSManaged public var overview: String
    @NSManaged public var currentWeather: CurrentWeatherCoreData?
    @NSManaged public var dailyWeather: DailyWeatherCoreData?
    @NSManaged public var hourlyWeather: HourlyWeatherCoreData?

}
