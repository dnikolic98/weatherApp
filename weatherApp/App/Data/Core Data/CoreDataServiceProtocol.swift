//
//  CoreDataServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

protocol CoreDataServiceProtocol {
    
    //MARK: - Fetches
    
    func fetchCurrentWeather() -> [CurrentWeatherCoreData]
    
    func fetchForecastWeather(coord: Coordinates) -> ForecastedWeatherCoreData?
    
    func fetchCurrentWeather(coord: Coordinates) -> CurrentWeatherCoreData?
    
    //MARK: - Create CoreData Models
    
    func createWeatherFrom(weather: Weather, currentWeather: CurrentWeatherCoreData) -> WeatherCoreData?
    
    func createWeatherFrom(weather: Weather, dailyWeather: DailyWeatherCoreData) -> WeatherCoreData?
    
    func createWindFrom(wind: Wind, currentWeather: CurrentWeatherCoreData) -> WindCoreData?
    
    func createForecastFrom(forecast: Forecast, currentWeather: CurrentWeatherCoreData) -> ForecastCoreData?
    
    func createCoordinatesFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCoreData) -> CoordinatesCoreData?
    
    func createCurrentWeatherFrom(currentWeather: CurrentWeather) -> CurrentWeatherCoreData?
    
    func createDailyTemperatureFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCoreData) -> DailyTemperatureCoreData?
    
    func createDailyWeatherFrom(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCoreData) -> DailyWeatherCoreData?
    
    func createForecastedWeatherFrom(forecastedWeather: ForecastedWeather) -> ForecastedWeatherCoreData?
    
    //MARK: - Save Changes
    
    func saveChanges()
}
