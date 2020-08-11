//
//  DetailWeatherPresnter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation


class DetailWeatherPresenter {
    
    let currentWeather: CurrentWeatherViewModel
    private var weatherConditionList: [(name: String, value: String)] = []
    
    init(currentWeather: CurrentWeatherViewModel) {
        self.currentWeather = currentWeather
        
        weatherConditionList.append((LocalizedStrings.feelsLike, String(format: LocalizedStrings.temperatureValueFormat, currentWeather.feelsLikeTemperature)))
        weatherConditionList.append((LocalizedStrings.humidity,  String(format: LocalizedStrings.percentageValueFormat, currentWeather.humidity)))
        weatherConditionList.append((LocalizedStrings.pressure,  String(format: LocalizedStrings.pressureValueFormat, currentWeather.pressure)))
        weatherConditionList.append((LocalizedStrings.wind, String(format: LocalizedStrings.speedValueFormat, currentWeather.windSpeed)))
    }
    
    func numberOfConditions() -> Int {
        return weatherConditionList.count
    }
    
    func numberOfConditionRows() -> Int {
        return numberOfConditions() / 2 + numberOfConditions() % 2
    }
    
    func weatherCondition(atIndex index: Int) -> (name: String, value: String)? {
           return weatherConditionList.at(index)
       }
       
}
