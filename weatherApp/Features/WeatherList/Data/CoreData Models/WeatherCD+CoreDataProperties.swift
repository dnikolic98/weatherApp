//
//  WeatherCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension WeatherCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCD> {
        return NSFetchRequest<WeatherCD>(entityName: "WeatherCD")
    }

    @NSManaged public var icon: String
    @NSManaged public var iconsUrlString: String
    @NSManaged public var overview: String
    @NSManaged public var currentWeather: CurrentWeatherCD?
    @NSManaged public var dailyWeather: DailyWeatherCD?

}
