//
//  CoordinatesCD+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 19/08/2020.
//
//

import Foundation
import CoreData


extension CoordinatesCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoordinatesCD> {
        return NSFetchRequest<CoordinatesCD>(entityName: "CoordinatesCD")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var currentWeather: CurrentWeatherCD

}
