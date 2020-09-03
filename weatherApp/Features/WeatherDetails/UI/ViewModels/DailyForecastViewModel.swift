//
//  DailyForecastViewModel.swift
//  weatherApp
//
//  Created by Dario Nikolic on 13/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

struct DailyForecastViewModel {
    
    let id: Int
    let name: String
    let forecastTime: Date
    let humidity: Int
    let pressure: Int
    let sunrise: Int
    let sunset: Int
    let maxTemperature: Int
    let minTemperature: Int
    let morningTemperature: Int
    let dayTemperature: Int
    let eveningTemperature: Int
    let nightTemperature: Int
    let weatherDescription: String
    let weatherIconUrlString: String
    let updatedInfo: String
    
    init(currentWeather: CurrentWeatherViewModel, dailyWeather: DailyWeatherCoreData) {
        id = currentWeather.id
        name = currentWeather.name
        humidity = Int(dailyWeather.humidity)
        pressure = Int(dailyWeather.pressure)
        maxTemperature = Int(dailyWeather.temperature.max)
        minTemperature = Int(dailyWeather.temperature.min)
        eveningTemperature = Int(dailyWeather.temperature.evening)
        dayTemperature = Int(dailyWeather.temperature.day)
        morningTemperature = Int(dailyWeather.temperature.morning)
        nightTemperature = Int(dailyWeather.temperature.night)
        weatherDescription = dailyWeather.weather.overview
        weatherIconUrlString = dailyWeather.weather.iconsUrlString
        sunrise = Int(dailyWeather.sunrise)
        sunset = Int(dailyWeather.sunset)
        forecastTime = Date(timeIntervalSince1970: TimeInterval(dailyWeather.forecastTime))
        updatedInfo = dailyWeather.updatedTime.dateTime()
    }
    
}
