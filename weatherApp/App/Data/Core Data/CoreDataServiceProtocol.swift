//
//  CoreDataServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

protocol CoreDataServiceProtocol {
    
    //MARK: - Fetches
    
    func fetchCurrentWeather() -> [CurrentWeatherCD]
    
    func fetchForecastWeather(coord: Coordinates) -> ForecastedWeatherCD?
    
    //MARK: - Create CoreData Models
    
    func createWeatherFrom(weather: Weather, currentWeather: CurrentWeatherCD) -> WeatherCD?
    
    func createWeatherFrom(weather: Weather, dailyWeather: DailyWeatherCD) -> WeatherCD?
    
    func createWindFrom(wind: Wind, currentWeather: CurrentWeatherCD) -> WindCD?
    
    func createForecastFrom(forecast: Forecast, currentWeather: CurrentWeatherCD) -> ForecastCD?
    
    func createCoordinatesFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCD) -> CoordinatesCD?
    
    func createCurrentWeatherFrom(currentWeather: CurrentWeather) -> CurrentWeatherCD?
    
    func createDailyTemperatureFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCD) -> DailyTemperatureCD?
    
    func createDailyWeatherFrom(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCD) -> DailyWeatherCD?
    
    func createForecastedWeatherFrom(forecastedWeather: ForecastedWeather) -> ForecastedWeatherCD?
    
    //MARK: - Save Changes
    
    func saveChanges()
}
