//
//  WindCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension WindCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindCoreData> {
        return NSFetchRequest<WindCoreData>(entityName: "WindCoreData")
    }

    @NSManaged public var directionDegree: Int64
    @NSManaged public var speed: Double
    @NSManaged public var currentWeather: CurrentWeatherCoreData

}
