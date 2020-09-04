//
//  CityCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 04/09/2020.
//
//

import Foundation
import CoreData


extension CityCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityCoreData> {
        return NSFetchRequest<CityCoreData>(entityName: "CityCoreData")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
