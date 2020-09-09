//
//  CoreDataServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

protocol CoreDataServiceProtocol {
    
    //MARK: - Fetches
    
    func fetchCurrentWeather(id: [Int]) -> [CurrentWeatherCoreData]
    
    func fetchForecastWeather(coord: Coordinates) -> ForecastedWeatherCoreData?
    
    func fetchCurrentWeather(coord: Coordinates) -> CurrentWeatherCoreData?
    
    func fetchCityList(query: String) -> [CityCoreData]
    
    func fetchSelectedLocations() -> [SelectedLocationCoreData]
    
    //MARK: - Create CoreData Models
    
    @discardableResult
    func createWeatherFrom(weather: Weather, currentWeather: CurrentWeatherCoreData) -> WeatherCoreData?
    
    @discardableResult
    func createWeatherFrom(weather: Weather, dailyWeather: DailyWeatherCoreData) -> WeatherCoreData?
    
    @discardableResult
    func createWindFrom(wind: Wind, currentWeather: CurrentWeatherCoreData) -> WindCoreData?
    
    @discardableResult
    func createForecastFrom(forecast: Forecast, currentWeather: CurrentWeatherCoreData) -> ForecastCoreData?
    
    @discardableResult
    func createCoordinatesFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCoreData) -> CoordinatesCoreData?
    
    @discardableResult
    func createCurrentWeatherFrom(currentWeather: CurrentWeather) -> CurrentWeatherCoreData?
    
    @discardableResult
    func createDailyTemperatureFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCoreData) -> DailyTemperatureCoreData?
    
    @discardableResult
    func createDailyWeatherFrom(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCoreData) -> DailyWeatherCoreData?
    
    @discardableResult
    func createForecastedWeatherFrom(forecastedWeather: ForecastedWeather) -> ForecastedWeatherCoreData?
    
    @discardableResult
    func createSelectedLocationFrom(id: Int) -> SelectedLocationCoreData?
    
    //MARK: - Remove core data models
    
    func removeSelectedLocation(id: Int)
    
    //MARK: - Save Changes
    
    func saveChanges()
}
