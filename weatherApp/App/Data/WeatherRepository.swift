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
    
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeatherCoreData]) -> Void)) {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCoreData = coreDataService.fetchCurrentWeather()
            completion(currentWeatherListCoreData)
        default:
            weatherService.fetchSeveralCurrentWeather(id: id) { [weak self] (currentWeatherList) in
                guard
                    let self = self,
                    currentWeatherList.count != 0
                else {
                    completion([])
                    return
                }
                let _ = currentWeatherList.map { self.coreDataService.createCurrentWeatherFrom(currentWeather: $0) }
                self.coreDataService.saveChanges()
                
                DispatchQueue.main.async {
                    let currentWeatherListCoreData = self.coreDataService.fetchCurrentWeather()
                    completion(currentWeatherListCoreData)
                }
            }
        }
    }
    
    func fetchForcastWeather(coord: Coordinates, completion: @escaping ((ForecastedWeatherCoreData?) -> Void)) {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCoreData = coreDataService.fetchForecastWeather(coord: coord)
            completion(currentWeatherListCoreData)
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
                    let currentWeatherListCoreData = self.coreDataService.fetchForecastWeather(coord: coord)
                    completion(currentWeatherListCoreData)
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
