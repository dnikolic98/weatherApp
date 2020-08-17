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
        temperature = Int(currentWeather.forecast.temperature)
        feelsLikeTemperature = Int(currentWeather.forecast.feelsLikeTemperature)
        maxTemperature = Int(currentWeather.forecast.maxTemperature)
        minTemperature = Int(currentWeather.forecast.minTemperature)
        windSpeed = currentWeather.wind.speed
        weatherDescription = currentWeather.weather.at(0)?.description ?? ""
        weatherIconUrlString = currentWeather.weather.at(0)?.iconUrlString ?? ""
        coord = currentWeather.coord
    }
    
}

