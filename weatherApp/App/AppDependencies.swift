//
//  AppDependencies.swift
//  weatherApp
//
//  Created by Dario Nikolic on 17/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Reachability

class AppDependencies {
    
    lazy var weatherService: WeatherServiceProtocol = {
        WeatherService()
    }()
    
    lazy var locationService: LocationService = {
        LocationService()
    }()
    
    lazy var reachability: Reachability = {
        try! Reachability()
    }()
    
    lazy var coreDataStack: CoreDataStack = {
        CoreDataStack(modelName: "weatherApp", completion: {})
    }()
    
    lazy var coreDataService: CoreDataService = {
        CoreDataService(coreDataStack: coreDataStack)
    }()
    
    lazy var weatherRepository: WeatherRepository = { WeatherRepository(weatherService: weatherService, coreDataService: coreDataService, reachability: reachability)
    }()
    
}
