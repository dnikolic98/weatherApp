//
//  CoreDataStackProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData

protocol CoreDataStackProtocol {
    
    var mainManagedObjectContext: NSManagedObjectContext { get }
    
    func saveChangesToDisk()
    
    func privateChildManagedObjectContext() -> NSManagedObjectContext
    
    func saveChangesSync(context: NSManagedObjectContext)
    
    func saveChangesAsync(context: NSManagedObjectContext)
    
}
