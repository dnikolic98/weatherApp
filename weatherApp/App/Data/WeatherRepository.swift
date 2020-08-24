//
//  WeatherRepository.swift
//  weatherApp
//
//  Created by Dario Nikolic on 18/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData
import Reachability

class WeatherRepository {
    
    let weatherService: WeatherServiceProtocol
    let coreDataService: CoreDataService
    let coreDataStack: CoreDataStack
    var reachability: Reachability
    
    init(weatherService: WeatherServiceProtocol, coreDataService: CoreDataService, coreDataStack: CoreDataStack, reachability: Reachability) {
        self.weatherService = weatherService
        self.reachability = reachability
        self.coreDataService = coreDataService
        self.coreDataStack = coreDataStack
        startReachability()
    }
    
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeatherCD]?) -> Void)) {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCD = coreDataService.fetchCurrentWeather()
            completion(currentWeatherListCD)
        default:
            self.weatherService.fetchSeveralCurrentWeather(id: id) { (currentWeatherList) in
                guard let currentWeatherList = currentWeatherList else {
                    completion(nil)
                    return
                }
                let privateContext = self.coreDataStack.privateChildManagedObjectContext()
                let _ = currentWeatherList.map { CurrentWeatherCD.createFrom(currentWeather: $0, context: privateContext) }
                self.saveChanges(managedObjectContext: privateContext)
                self.coreDataStack.saveChanges()
                
                DispatchQueue.main.async {
                    let currentWeatherListCD = self.coreDataService.fetchCurrentWeather()
                    completion(currentWeatherListCD)
                }
            }
        }
    }
    
    func fetchForcastWeather(coord: Coordinates, completion: @escaping ((ForecastedWeatherCD?) -> Void)) {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCD = coreDataService.fetchForecastWeather(coord: coord)
            completion(currentWeatherListCD)
        default:
            self.weatherService.fetchForcastWeather(coord: coord) { (forecastedWeather) in
                guard let forecastedWeather = forecastedWeather else {
                    completion(nil)
                    return
                }
                let privateContext = self.coreDataStack.privateChildManagedObjectContext()
                let _ = ForecastedWeatherCD.createFrom(forecastedWeather: forecastedWeather, context: privateContext)
                self.saveChanges(managedObjectContext: privateContext)
                self.coreDataStack.saveChanges()
                
                DispatchQueue.main.async {
                    let currentWeatherListCD = self.coreDataService.fetchForecastWeather(coord: coord)
                    completion(currentWeatherListCD)
                }
            }
        }
    }
    
    private func startReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func saveChanges(managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.performAndWait {
            do {
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
}
