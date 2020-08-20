//
//  CurrentWeatherCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension CurrentWeatherCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherCD> {
        return NSFetchRequest<CurrentWeatherCD>(entityName: "CurrentWeatherCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var coord: CoordinatesCD?
    @NSManaged public var forecast: ForecastCD?
    @NSManaged public var weather: WeatherCD?
    @NSManaged public var wind: WindCD?

}
