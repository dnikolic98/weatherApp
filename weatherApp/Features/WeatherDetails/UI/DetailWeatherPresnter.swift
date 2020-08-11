//
//  DetailWeatherPresnter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class DetailWeatherPresenter {
    
    let currentWeather: CurrentWeatherViewModel
    var numberOfConditions: Int {
        weatherConditionList.count
    }
    var numberOfConditionRows: Int {
        numberOfConditions / 2 + numberOfConditions % 2
    }
    
    private var weatherConditionList: [ConditionInformationViewModel] = []
    
    init(currentWeather: CurrentWeatherViewModel) {
        self.currentWeather = currentWeather
        
        setWeatherConditionList()
    }
    
    private func setWeatherConditionList() {
        let feelsLikeTemperature = ConditionInformationViewModel(title: LocalizedStrings.feelsLike, value: String(format: LocalizedStrings.temperatureValueFormat, currentWeather.feelsLikeTemperature))
        let humidity =  ConditionInformationViewModel(title: LocalizedStrings.humidity, value: String(format: LocalizedStrings.percentageValueFormat, currentWeather.humidity))
        let pressure = ConditionInformationViewModel(title: LocalizedStrings.pressure, value: String(format: LocalizedStrings.pressureValueFormat, currentWeather.pressure))
        let windSpeed = ConditionInformationViewModel(title: LocalizedStrings.wind, value: String(format: LocalizedStrings.speedValueFormat, currentWeather.windSpeed))
        
        weatherConditionList.append(feelsLikeTemperature)
        weatherConditionList.append(humidity)
        weatherConditionList.append(pressure)
        weatherConditionList.append(windSpeed)
    }
    
    func weatherCondition(atIndex index: Int) -> ConditionInformationViewModel? {
           return weatherConditionList.at(index)
       }
       
}
