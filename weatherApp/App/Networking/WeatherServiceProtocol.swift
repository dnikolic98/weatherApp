//
//  WeatherServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 17/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift

protocol WeatherServiceProtocol {
    
    func fetchForecastWeather(coord: Coordinates) -> Observable<ForecastedWeather>
    
    func fetchSeveralCurrentWeather(id: [Int]) -> Observable<MultipleCurrentWeather>
    
    func fetchCurrentWeather(coord: Coordinates) -> Observable<CurrentWeather>
    
}
