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
    
    lazy var reachability: Reachability = {
        try! Reachability()
    }()
    
    lazy var weatherRepository: WeatherRepository = {
        WeatherRepository(weatherService: weatherService, reachability: reachability)
    }()

}
