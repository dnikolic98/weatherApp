//
//  CurrentWeatherViewModel.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct CurrentWeatherViewModel {
    
    let id: Int
    let name: String
    let humidity: Int
    let pressure: Int
    let temperature: Int
    let feelsLikeTemperature: Int
    let maxTemperature: Int
    let minTemperature: Int
    let windSpeed: Double
    let weatherDescription: String
    let weatherIconUrlString: String
    let coord: Coordinates
    
    init(currentWeather: CurrentWeather) {
        id = currentWeather.id
        name = currentWeather.name
        humidity = currentWeather.forecast.humidity
        pressure = currentWeather.forecast.pressure
        temperature = Int(currentWeather.forecast.temperature.celsius)
        feelsLikeTemperature = Int(currentWeather.forecast.feelsLikeTemperature.celsius)
        maxTemperature = Int(currentWeather.forecast.maxTemperature.celsius)
        minTemperature = Int(currentWeather.forecast.minTemperature.celsius)
        windSpeed = currentWeather.wind.speed
        weatherDescription = currentWeather.weather.description
        weatherIconUrlString = currentWeather.weather.iconUrlString
        coord = currentWeather.coord
    }
    
}

