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
    
    
    init(currentWeather: CurrentWeatherViewModel, dailyWeather: DailyWeather) {
        id = currentWeather.id
        name = currentWeather.name
        humidity = dailyWeather.humidity
        pressure = Int(dailyWeather.pressure)
        maxTemperature = Int(dailyWeather.temperature.max)
        minTemperature = Int(dailyWeather.temperature.min)
        eveningTemperature = Int(dailyWeather.temperature.evening)
        dayTemperature = Int(dailyWeather.temperature.day)
        morningTemperature = Int(dailyWeather.temperature.morning)
        nightTemperature = Int(dailyWeather.temperature.night)
        weatherDescription = dailyWeather.weather.at(0)?.description ?? ""
        weatherIconUrlString = dailyWeather.weather.at(0)?.iconUrlString ?? ""
        sunrise = dailyWeather.sunrise
        sunset = dailyWeather.sunset
        forecastTime = Date(timeIntervalSince1970: TimeInterval(dailyWeather.forecastTime))
    }
    
}
