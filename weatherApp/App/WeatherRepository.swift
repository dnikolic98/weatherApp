//
//  WeatherRepository.swift
//  weatherApp
//
//  Created by Dario Nikolic on 18/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation
import Reachability

class WeatherRepository {
    
    let weatherService: WeatherServiceProtocol
    let reachability: Reachability
    
    init(weatherService: WeatherServiceProtocol, reachability: Reachability) {
        self.weatherService = weatherService
        self.reachability = reachability
        startReachability()
    }
    
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeather]?) -> Void)) {
        reachability.whenReachable = { _ in
            self.weatherService.fetchSeveralCurrentWeather(id: id) { (currentWeatherList) in
                completion(currentWeatherList)
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
    }
    
    func fetchForcastWeather(coord: Coordinates, completion: @escaping ((ForecastedWeather?) -> Void)) {
        
        reachability.whenReachable = { _ in
            self.weatherService.fetchForcastWeather(coord: coord) { (forecastedWeather) in
                completion(forecastedWeather)
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
    }
    
    private func startReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}
