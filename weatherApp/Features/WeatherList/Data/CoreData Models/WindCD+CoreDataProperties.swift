//
//  WindCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension WindCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindCD> {
        return NSFetchRequest<WindCD>(entityName: "WindCD")
    }

    @NSManaged public var directionDegree: Int64
    @NSManaged public var speed: Double
    @NSManaged public var currentWeather: CurrentWeatherCD

}