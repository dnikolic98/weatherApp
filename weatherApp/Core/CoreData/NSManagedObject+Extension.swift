//
//  NSManagedObject+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 24/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    class func firstOrCreate(withPredicate predicate: NSPredicate, context: NSManagedObjectContext) -> Self? {
        let request: NSFetchRequest<Self> = Self.fetchRequest() as! NSFetchRequest<Self>
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let fetched = try context.fetch(request)
            
            guard let old = fetched.first else {
                let new = Self(context: context)
                return new
            }
            
            return old
        } catch {
            return nil
        }
    }
    
}
