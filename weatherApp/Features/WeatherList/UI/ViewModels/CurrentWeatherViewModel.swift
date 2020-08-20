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
    
    init(currentWeather: CurrentWeatherCD) {
        id = Int(currentWeather.id)
        name = currentWeather.name
        humidity = Int(currentWeather.forecast.humidity)
        pressure = Int(currentWeather.forecast.pressure)
        temperature = Int(currentWeather.forecast.temperature)
        feelsLikeTemperature = Int(currentWeather.forecast.feelsLikeTemperature)
        maxTemperature = Int(currentWeather.forecast.maxTemperature)
        minTemperature = Int(currentWeather.forecast.minTemperature)
        windSpeed = currentWeather.wind.speed
        weatherDescription = currentWeather.weather.overview
        weatherIconUrlString = currentWeather.weather.iconsUrlString
        coord = Coordinates.init(latitude: currentWeather.coord.latitude, longitude: currentWeather.coord.longitude)
    }
    
}

