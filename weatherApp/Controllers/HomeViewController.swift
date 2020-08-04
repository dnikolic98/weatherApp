//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeather()
    }
    
    private func fetchWeather() {
        for city in Cities.allCases {
            WeatherService().fetchCurrentWeather(id: city.rawValue) { (currentWeather) in
                if let currentWeather = currentWeather {
                    print(currentWeather.name)
                    print(currentWeather.forecast.convertToCelsius(degrees: currentWeather.forecast.temp))
                    print(currentWeather.forecast.temp)
                    print()
                }
            }
        }
    }
    
}
