//
//  AppDependencies.swift
//  weatherApp
//
//  Created by Dario Nikolic on 17/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class AppDependencies {
    
    lazy var weatherService: WeatherServiceProtocol = WeatherService()
    
}
