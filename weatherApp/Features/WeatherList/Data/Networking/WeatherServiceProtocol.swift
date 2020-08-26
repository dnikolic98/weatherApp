//
//  WeatherServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 17/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

protocol WeatherServiceProtocol {
    
    func fetchForcastWeather(coord: Coordinates, completion: @escaping ((ForecastedWeather?) -> Void))
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeather]?) -> Void))
    
    func fetchCurrentWeather(coord: Coordinates, completion: @escaping ((CurrentWeather?) -> Void))

}
