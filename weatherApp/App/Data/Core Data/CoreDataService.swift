//
//  CoreDataService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 24/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData

class CoreDataService {
    
    private let coreDataStack: CoreDataStack
    private let mainContext: NSManagedObjectContext
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.mainContext = coreDataStack.mainManagedObjectContext
    }
    
    //MARK: - Fetches
    
    func fetchCurrentWeather() -> [CurrentWeatherCD]? {
        
        let request: NSFetchRequest<CurrentWeatherCD> = CurrentWeatherCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let currentWeatherList = try? mainContext.fetch(request)
        return currentWeatherList
    }
    
    func fetchForecastWeather(coord: Coordinates) -> ForecastedWeatherCD? {
        let lon = coord.longitude
        let lat = coord.latitude
        
        let request: NSFetchRequest<ForecastedWeatherCD> = ForecastedWeatherCD.fetchRequest()
        let epsilon = 0.00001
        let format = "longitude > %f AND longitude < %f AND latitude > %f AND latitude < %f"
        request.predicate = NSPredicate(format: format, lon-epsilon, lon+epsilon, lat-epsilon, lat+epsilon)
        
        let forecastedWeatherCD = try? mainContext.fetch(request)
        return forecastedWeatherCD?.first
    }
    
    //MARK: - First Or Create
    
//    func firstOrCreateWeather(withCurrentWeather currentWeather: CurrentWeatherCD, context: NSManagedObjectContext) {
//        
//    }
    
    
}
