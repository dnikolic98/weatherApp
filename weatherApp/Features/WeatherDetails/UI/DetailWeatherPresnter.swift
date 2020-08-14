//
//  DetailWeatherPresnter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class DetailWeatherPresenter {
    
    private var sevenDayForecast: [DailyForecastViewModel] = []
    private var weatherConditionList: [ConditionInformationViewModel] = []
    private var fiveDaysList: [SingleWeatherInformationViewModel] = []
    
    let currentWeather: CurrentWeatherViewModel
    var numberOfConditions: Int {
        weatherConditionList.count
    }
    var numberOfConditionRows: Int {
        numberOfConditions / 2 + numberOfConditions % 2
    }
    var numberOfDays: Int {
        fiveDaysList.count
    }
    
    init(currentWeather: CurrentWeatherViewModel) {
        self.currentWeather = currentWeather

        setWeatherConditionList()
    }
    
    func weatherCondition(atIndex index: Int) -> ConditionInformationViewModel? {
        return weatherConditionList.at(index)
    }
    
    func fiveDays(atIndex index: Int) -> SingleWeatherInformationViewModel? {
        return fiveDaysList.at(index)
    }
    
    func fetchFiveDaysList(completion: @escaping ((ForecastedWeather?) -> Void)) {
        WeatherService().fetchForcastWeather(coord: currentWeather.coord) { [weak self] (fiveDaysForecast) in
            guard
                let self = self,
                let fiveDaysForecast = fiveDaysForecast
            else {
                completion(nil)
                return
            }
            
            self.sevenDayForecast = fiveDaysForecast.forecastedWeather.map { DailyForecastViewModel(currentWeather: self.currentWeather, dailyWeather: $0) }
            
            self.setFiveDayList()
            completion(fiveDaysForecast)
        }
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
    
    private func setFiveDayList() {
        guard sevenDayForecast.count >= 7 else { return }
        
        for forecast in sevenDayForecast[1...5] {
            let minTempValue = String(format: LocalizedStrings.degreeValueFormat, forecast.minTemperature)
            let maxTempValue = String(format: LocalizedStrings.degreeValueFormat, forecast.maxTemperature)
            let temperature = "\(maxTempValue)\n\(minTempValue)"
            let day = forecast.forecastTime.dayOfWeek().uppercased()
            
            fiveDaysList.append(SingleWeatherInformationViewModel(header: day, body: temperature, iconUrlString: forecast.weatherIconUrlString))
        }
    }
    
}
