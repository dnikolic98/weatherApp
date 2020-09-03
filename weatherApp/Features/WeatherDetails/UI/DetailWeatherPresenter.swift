//
//  DetailWeatherPresnter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class DetailWeatherPresenter {
    
    private let weatherRepository: WeatherRepository
    private var sevenDayForecast: [DailyForecastViewModel] = []
    private var weatherConditionList: [ConditionInformationViewModel] = []
    private var fiveDaysList: [SingleWeatherInformationViewModel] = []
    
    var currentWeather: CurrentWeatherViewModel
    var numberOfConditions: Int {
        weatherConditionList.count
    }
    var numberOfConditionRows: Int {
        numberOfConditions / 2 + numberOfConditions % 2
    }
    var numberOfDays: Int {
        fiveDaysList.count
    }
    
    init(currentWeather: CurrentWeatherViewModel, weatherRepository: WeatherRepository) {
        self.currentWeather = currentWeather
        self.weatherRepository = weatherRepository

        setWeatherConditionList()
    }
    
    func weatherCondition(atIndex index: Int) -> ConditionInformationViewModel? {
        return weatherConditionList.at(index)
    }

    func fiveDays(atIndex index: Int) -> SingleWeatherInformationViewModel? {
        return fiveDaysList.at(index)
    }
    
    func fetchFiveDaysList(completion: @escaping ((ForecastedWeatherCoreData?) -> Void)) {
        weatherRepository.fetchForcastWeather(coord: currentWeather.coord) { [weak self] fiveDaysForecast in
            guard
                let self = self,
                let fiveDaysForecast = fiveDaysForecast
            else {
                completion(nil)
                return
            }
            
            self.sevenDayForecast = fiveDaysForecast.forecastedWeather
                .map { DailyForecastViewModel(currentWeather: self.currentWeather, dailyWeather: $0 as! DailyWeatherCoreData) }
                .sorted { $0.forecastTime < $1.forecastTime }
            
            self.setFiveDayList()
            completion(fiveDaysForecast)
        }
    }
    
    func fetchCurrentWeather(completion: @escaping ((CurrentWeatherViewModel?) -> Void)) {
        let coord = currentWeather.coord
        weatherRepository.fetchCurrentWeather(coord: coord) { [weak self] currentWeather in
            guard
                let self = self,
                let currentWeather = currentWeather
            else {
                completion(nil)
                return
            }
            
            self.currentWeather = CurrentWeatherViewModel(currentWeather: currentWeather)
            completion(self.currentWeather)
        }
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
