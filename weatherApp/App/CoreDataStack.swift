//
//  CoreData.swift
//  weatherApp
//
//  Created by Dario Nikolic on 19/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "weatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchCurrentWeather() -> [CurrentWeatherCD]? {
        let request: NSFetchRequest<CurrentWeatherCD> = CurrentWeatherCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let currentWeatherList = try? context.fetch(request)
        return currentWeatherList
    }
    
    func fetchForecastWeather(coord: Coordinates) -> ForecastedWeatherCD? {
        let lon = coord.longitude
        let lat = coord.latitude
        
        let request: NSFetchRequest<ForecastedWeatherCD> = ForecastedWeatherCD.fetchRequest()
        let epsilon = 0.00001
        request.predicate = NSPredicate(format: "longitude > %f AND longitude < %f AND latitude > %f AND latitude < %f", lon-epsilon, lon+epsilon, lat-epsilon, lat+epsilon)
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let forecastedWeatherCD = try? context.fetch(request)
        return forecastedWeatherCD?.first
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
