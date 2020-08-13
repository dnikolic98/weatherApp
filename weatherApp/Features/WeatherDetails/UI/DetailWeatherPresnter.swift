//
//  DetailWeatherPresnter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class DetailWeatherPresenter {
    
    private var weatherConditionList: [ConditionInformationViewModel] = []
    
    let currentWeather: CurrentWeatherViewModel
    var numberOfConditions: Int {
        weatherConditionList.count
    }
    var numberOfConditionRows: Int {
        numberOfConditions / 2 + numberOfConditions % 2
    }
    
    init(currentWeather: CurrentWeatherViewModel) {
        self.currentWeather = currentWeather
        
        setWeatherConditionList()
    }
    
    func weatherCondition(atIndex index: Int) -> ConditionInformationViewModel? {
        return weatherConditionList.at(index)
    }
    
    private func setWeatherConditionList() {
        let feelsLikeTemperatureValue = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.feelsLikeTemperature)
        let humidityValue = String(format: LocalizedStrings.percentageValueFormat, currentWeather.humidity)
        let pressureValue = String(format: LocalizedStrings.pressureValueFormat, currentWeather.pressure)
        let windSpeedValue = String(format: LocalizedStrings.speedValueFormat, currentWeather.windSpeed)
        
        let feelsLikeTemperature = ConditionInformationViewModel(title: LocalizedStrings.feelsLike, value: feelsLikeTemperatureValue)
        let humidity =  ConditionInformationViewModel(title: LocalizedStrings.humidity, value: humidityValue)
        let pressure = ConditionInformationViewModel(title: LocalizedStrings.pressure, value: pressureValue)
        let windSpeed = ConditionInformationViewModel(title: LocalizedStrings.wind, value: windSpeedValue)
        
        weatherConditionList.append(feelsLikeTemperature)
        weatherConditionList.append(humidity)
        weatherConditionList.append(pressure)
        weatherConditionList.append(windSpeed)
    }
    
}
