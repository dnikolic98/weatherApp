//
//  CoordinatesCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension CoordinatesCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoordinatesCoreData> {
        return NSFetchRequest<CoordinatesCoreData>(entityName: "CoordinatesCoreData")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var currentWeather: CurrentWeatherCoreData

}
