//
//  WeatherRepository.swift
//  weatherApp
//
//  Created by Dario Nikolic on 18/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

class WeatherRepository {
    
    let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeather]?) -> Void)) {
        weatherService.fetchSeveralCurrentWeather(id: id) { (currentWeatherList) in
            completion(currentWeatherList)
        }
    }
    
    func fetchForcastWeather(coord: Coordinates, completion: @escaping ((ForecastedWeather?) -> Void)) {
        weatherService.fetchForcastWeather(coord: coord) { (forecastedWeather) in
            completion(forecastedWeather)
        }
    }
    
}
