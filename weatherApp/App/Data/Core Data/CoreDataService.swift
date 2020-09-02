//
//  CoreDataService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 24/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData

class CoreDataService: CoreDataServiceProtocol {
    
    //MARK: - Properties
    
    private let coreDataStack: CoreDataStackProtocol
    private let mainContext: NSManagedObjectContext
    private let privateContext: NSManagedObjectContext
    
    //MARK: - Initialization
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
        self.mainContext = coreDataStack.mainManagedObjectContext
        self.privateContext = coreDataStack.privateChildManagedObjectContext()
    }
    
    //MARK: - Fetches
    
    func fetchCurrentWeather() -> [CurrentWeatherCoreData] {
        let request: NSFetchRequest<CurrentWeatherCoreData> = CurrentWeatherCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        guard let currentWeatherList = try? mainContext.fetch(request) else {
            return []
        }
        
        return currentWeatherList
    }
    
    func fetchForecastWeather(coord: Coordinates) -> ForecastedWeatherCoreData? {
        let request: NSFetchRequest<ForecastedWeatherCoreData> = ForecastedWeatherCoreData.fetchRequest()
        request.predicate = Predicates.coordinatesPredicate(coord)
        
        let forecastedWeatherCoreData = try? mainContext.fetch(request)
        return forecastedWeatherCoreData?.first
    }
    
    
    //MARK: - Create CoreData Models
    
    func createWeatherFrom(weather: Weather, currentWeather: CurrentWeatherCoreData) -> WeatherCoreData? {
        guard let weatherCoreData = WeatherCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        weatherCoreData.populate(weather: weather, currentWeather: currentWeather)
        return weatherCoreData
    }
    
    func createWeatherFrom(weather: Weather, dailyWeather: DailyWeatherCoreData) -> WeatherCoreData? {
        guard let weatherCoreData = WeatherCoreData.firstOrCreate(withDailyWeather: dailyWeather, context: privateContext) else { return nil }
        weatherCoreData.populate(weather: weather, dailyWeather: dailyWeather)
        return weatherCoreData
    }
    
    func createWindFrom(wind: Wind, currentWeather: CurrentWeatherCoreData) -> WindCoreData? {
        guard let windCoreData = WindCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        windCoreData.populate(wind: wind, currentWeather: currentWeather)
        return windCoreData
    }
    
    func createForecastFrom(forecast: Forecast, currentWeather: CurrentWeatherCoreData) -> ForecastCoreData? {
        guard let forecastCoreData = ForecastCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        forecastCoreData.populate(forecast: forecast, currentWeather: currentWeather)
        return forecastCoreData
    }
    
    func createCoordinatesFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCoreData) -> CoordinatesCoreData? {
        guard let coordinatesCoreData = CoordinatesCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        coordinatesCoreData.populate(coordinates: coordinates, currentWeather: currentWeather)
        return coordinatesCoreData
    }
    
    func createCurrentWeatherFrom(currentWeather: CurrentWeather) -> CurrentWeatherCoreData? {
        guard
            let currentWeatherCoreData = CurrentWeatherCoreData.firstOrCreate(withId: currentWeather.id, context: privateContext),
            let weather = currentWeather.weather.at(0),
            let weatherCoreData = createWeatherFrom(weather: weather, currentWeather: currentWeatherCoreData),
            let coordCoreData = createCoordinatesFrom(coordinates: currentWeather.coord, currentWeather: currentWeatherCoreData),
            let windCoreData = createWindFrom(wind: currentWeather.wind, currentWeather: currentWeatherCoreData),
            let forecastCoreData = createForecastFrom(forecast: currentWeather.forecast, currentWeather: currentWeatherCoreData)
        else {
            return nil
        }
        currentWeatherCoreData.populate(currentWeather: currentWeather, forecast: forecastCoreData, weather: weatherCoreData, coord: coordCoreData, wind: windCoreData)
        return currentWeatherCoreData
    }
    
    func createDailyTemperatureFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCoreData) -> DailyTemperatureCoreData? {
        guard let dailyTemperatureCoreData = DailyTemperatureCoreData.firstOrCreate(withDailyWeather: dailyWeather, context: privateContext) else { return nil }
        dailyTemperatureCoreData.populate(dailyTemperature: dailyTemperature, dailyWeather: dailyWeather)
        return dailyTemperatureCoreData
    }
    
    
    func createDailyWeatherFrom(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCoreData) -> DailyWeatherCoreData? {
        guard
            let dailyWeatherCoreData = DailyWeatherCoreData.firstOrCreate(withForecastedWeather: forecastedWeather, withId: indexId, context: privateContext),
            let weather = dailyWeather.weather.at(0),
            let temperatureCoreData = createDailyTemperatureFrom(dailyTemperature: dailyWeather.temperature, dailyWeather: dailyWeatherCoreData),
            let weatherCoreData = createWeatherFrom(weather: weather, dailyWeather: dailyWeatherCoreData)
        else {
            return nil
        }
        dailyWeatherCoreData.populate(dailyWeather: dailyWeather, indexId: indexId, forecastedWeather: forecastedWeather, temperature: temperatureCoreData, weather: weatherCoreData)
        return dailyWeatherCoreData
    }
    
    func createForecastedWeatherFrom(forecastedWeather: ForecastedWeather) -> ForecastedWeatherCoreData? {
        guard let forecastedWeatherCoreData = ForecastedWeatherCoreData.firstOrCreate(withLongitude: forecastedWeather.longitude, withLatitude: forecastedWeather.latitude, context: privateContext) else { return nil }
        var dailyWeathers: [DailyWeatherCoreData] = []
        for (index, dailyWeather) in forecastedWeather.forecastedWeather.enumerated() {
            if let dailyWeatherCoreData = createDailyWeatherFrom(dailyWeather: dailyWeather, indexId: index, forecastedWeather: forecastedWeatherCoreData) {
                dailyWeathers.append(dailyWeatherCoreData)
            }
        }
        forecastedWeatherCoreData.populate(forecastedWeather: forecastedWeather, dailyWeathers: dailyWeathers)
        return forecastedWeatherCoreData
    }
    
    //MARK: - Save Changes
    
    func saveChanges() {
        coreDataStack.saveChangesSync(context: privateContext)
        coreDataStack.saveChangesToDisk()
    }
    
}
