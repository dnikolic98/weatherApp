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
    var reachability: Reachability
    
    init(weatherService: WeatherServiceProtocol, reachability: Reachability) {
        self.weatherService = weatherService
        self.reachability = reachability
        startReachability()
    }
    
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeatherCD]?) -> Void)) {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCD = CoreDataStack.shared.fetchCurrentWeather()
            completion(currentWeatherListCD)
        default:
            self.weatherService.fetchSeveralCurrentWeather(id: id) { (currentWeatherList) in
                guard let currentWeatherList = currentWeatherList else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    let _ = currentWeatherList.map { CurrentWeatherCD.createFrom(currentWeather: $0) }
                    let currentWeatherListCD = CoreDataStack.shared.fetchCurrentWeather()
                    completion(currentWeatherListCD)
                }
            }
        }
    }
    
    func fetchForcastWeather(coord: Coordinates, completion: @escaping ((ForecastedWeatherCD?) -> Void)) {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCD = CoreDataStack.shared.fetchForecastWeather(coord: coord)
            completion(currentWeatherListCD)
        default:
            self.weatherService.fetchForcastWeather(coord: coord) { (forecastedWeather) in
                guard let forecastedWeather = forecastedWeather else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    let _ = ForecastedWeatherCD.createFrom(forecastedWeather: forecastedWeather)
                    let currentWeatherListCD = CoreDataStack.shared.fetchForecastWeather(coord: coord)
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
    
}
