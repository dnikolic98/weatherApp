//
//  CoreData.swift
//  weatherApp
//
//  Created by Dario Nikolic on 19/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    public typealias CoreDataManagerCompletion = () -> ()
    
    // MARK: - Properties
    
    private let modelName: String
    private let completion: CoreDataManagerCompletion
    
    // MARK: - Initialization
    
    public init(modelName: String, completion: @escaping CoreDataManagerCompletion) {
        self.modelName = modelName
        self.completion = completion
        
        setupCoreDataStack()
    }
    
    // MARK: - Core Data Stack
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    public private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()
    
    // MARK: - Public API
    
    public func saveChangesToDisk() {
        saveChangesSync(context: mainManagedObjectContext)
        saveChangesAsync(context: privateManagedObjectContext)
    }
    
    public func privateChildManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContext.parent = mainManagedObjectContext
        return managedObjectContext
    }
    
    public func saveChangesSync(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    public func saveChangesAsync(context: NSManagedObjectContext) {
        context.perform {
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupCoreDataStack() {
        guard let persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator else {
            fatalError("Unable to Set Up Core Data Stack")
        }
        
        DispatchQueue.global().async {
            self.addPersistentStore(to: persistentStoreCoordinator)
            
            DispatchQueue.main.async { self.completion() }
        }
    }
    
    private func addPersistentStore(to persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
            ]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
            
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
    }
    
}
