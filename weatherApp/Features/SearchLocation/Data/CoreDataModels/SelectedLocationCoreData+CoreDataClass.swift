//
//  SelectedLocationCoreData+CoreDataClass.swift
//  
//
//  Created by Dario Nikolic on 07/09/2020.
//
//

import Foundation
import CoreData

@objc(SelectedLocationCoreData)
public class SelectedLocationCoreData: NSManagedObject {
    
    class func firstOrCreate(withId id: Int, context: NSManagedObjectContext) -> SelectedLocationCoreData? {
        let predicate = Predicates.idPredicate(id)
        return firstOrCreate(withPredicate: predicate, context: context)
    }
    
    func populate(id: Int) {
        self.id = Int64(id)
    }
    
}
