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
    let coreDataService: CoreDataServiceProtocol
    var reachability: Reachability
    
    init(weatherService: WeatherServiceProtocol, coreDataService: CoreDataServiceProtocol, reachability: Reachability) {
        self.weatherService = weatherService
        self.reachability = reachability
        self.coreDataService = coreDataService
        startReachability()
    }
    
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeatherCD]?) -> Void)) {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCD = coreDataService.fetchCurrentWeather()
            completion(currentWeatherListCD)
        default:
            weatherService.fetchSeveralCurrentWeather(id: id) { [weak self] (currentWeatherList) in
                guard
                    let self = self,
                    let currentWeatherList = currentWeatherList
                else {
                    completion(nil)
                    return
                }
                let _ = currentWeatherList.map { self.coreDataService.createCurrentWeatherFrom(currentWeather: $0) }
                self.coreDataService.saveChanges()
                
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
            weatherService.fetchForcastWeather(coord: coord) { [weak self] (forecastedWeather) in
                guard
                    let self = self,
                    let forecastedWeather = forecastedWeather
                else {
                    completion(nil)
                    return
                }
                
                let _ = self.coreDataService.createForecastedWeatherFrom(forecastedWeather: forecastedWeather)
                self.coreDataService.saveChanges()
                
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
    
}
