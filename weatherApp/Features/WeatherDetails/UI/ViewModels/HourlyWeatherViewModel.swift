//
//  HourlyWeatherViewModel.swift
//  weatherApp
//
//  Created by Dario Nikolic on 24/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

struct HourlyWeatherViewModel {
    
    let id: Int
    let name: String
    let forecastTime: Date
    let humidity: Int
    let pressure: Int
    let temperature: Int
    let weatherDescription: String
    let weatherIconUrlString: String
    let updatedInfo: String
    
    init(currentWeather: CurrentWeatherViewModel, hourlyWeather: HourlyWeatherCoreData) {
        id = currentWeather.id
        name = currentWeather.name
        humidity = Int(hourlyWeather.humidity)
        pressure = Int(hourlyWeather.pressure)
        temperature = Int(hourlyWeather.temperature)
        weatherDescription = hourlyWeather.weather.overview
        weatherIconUrlString = hourlyWeather.weather.iconsUrlString
        forecastTime = Date(timeIntervalSince1970: TimeInterval(hourlyWeather.forecastTime))
        updatedInfo = hourlyWeather.updatedTime.dateTime()
    }
    
}
