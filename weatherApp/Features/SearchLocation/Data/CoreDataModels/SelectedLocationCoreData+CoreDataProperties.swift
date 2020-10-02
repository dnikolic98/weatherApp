//
//  SelectedLocationCoreData+CoreDataProperties.swift
//  
//
//  Created by Dario Nikolic on 07/09/2020.
//
//

import Foundation
import CoreData


extension SelectedLocationCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectedLocationCoreData> {
        return NSFetchRequest<SelectedLocationCoreData>(entityName: "SelectedLocationCoreData")
    }

    @NSManaged public var id: Int64

}
