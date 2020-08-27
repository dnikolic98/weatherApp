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
    
    func fetchCurrentWeather() -> [CurrentWeatherCD] {
        let request: NSFetchRequest<CurrentWeatherCD> = CurrentWeatherCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        guard let currentWeatherList = try? mainContext.fetch(request) else {
            return []
        }
        
        return currentWeatherList
    }
    
    func fetchForecastWeather(coord: Coordinates) -> ForecastedWeatherCD? {
        let lon = coord.longitude
        let lat = coord.latitude
        
        let request: NSFetchRequest<ForecastedWeatherCD> = ForecastedWeatherCD.fetchRequest()
        let epsilon = 0.00001
        let format = "longitude > %f AND longitude < %f AND latitude > %f AND latitude < %f"
        request.predicate = NSPredicate(format: format, lon-epsilon, lon+epsilon, lat-epsilon, lat+epsilon)
        
        let forecastedWeatherCD = try? mainContext.fetch(request)
        return forecastedWeatherCD?.first
    }
    
    
    //MARK: - Create CoreData Models
    
    func createWeatherFrom(weather: Weather, currentWeather: CurrentWeatherCD) -> WeatherCD? {
        guard let weatherCD = WeatherCD.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        weatherCD.populate(weather: weather, currentWeather: currentWeather)
        return weatherCD
    }
    
    func createWeatherFrom(weather: Weather, dailyWeather: DailyWeatherCD) -> WeatherCD? {
        guard let weatherCD = WeatherCD.firstOrCreate(withDailyWeather: dailyWeather, context: privateContext) else { return nil }
        weatherCD.populate(weather: weather, dailyWeather: dailyWeather)
        return weatherCD
    }
    
    func createWindFrom(wind: Wind, currentWeather: CurrentWeatherCD) -> WindCD? {
        guard let windCD = WindCD.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        windCD.populate(wind: wind, currentWeather: currentWeather)
        return windCD
    }
    
    func createForecastFrom(forecast: Forecast, currentWeather: CurrentWeatherCD) -> ForecastCD? {
        guard let forecastCD = ForecastCD.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        forecastCD.populate(forecast: forecast, currentWeather: currentWeather)
        return forecastCD
    }
    
    func createCoordinatesFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCD) -> CoordinatesCD? {
        guard let coordinatesCD = CoordinatesCD.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        coordinatesCD.populate(coordinates: coordinates, currentWeather: currentWeather)
        return coordinatesCD
    }
    
    func createCurrentWeatherFrom(currentWeather: CurrentWeather) -> CurrentWeatherCD? {
        guard
            let currentWeatherCD = CurrentWeatherCD.firstOrCreate(withId: currentWeather.id, context: privateContext),
            let weather = currentWeather.weather.at(0),
            let weatherCD = createWeatherFrom(weather: weather, currentWeather: currentWeatherCD),
            let coordCD = createCoordinatesFrom(coordinates: currentWeather.coord, currentWeather: currentWeatherCD),
            let windCD = createWindFrom(wind: currentWeather.wind, currentWeather: currentWeatherCD),
            let forecastCD = createForecastFrom(forecast: currentWeather.forecast, currentWeather: currentWeatherCD)
        else {
            return nil
        }
        currentWeatherCD.populate(currentWeather: currentWeather, forecast: forecastCD, weather: weatherCD, coord: coordCD, wind: windCD)
        return currentWeatherCD
    }
    
    func createDailyTemperatureFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCD) -> DailyTemperatureCD? {
        guard let dailyTemperatureCD = DailyTemperatureCD.firstOrCreate(withDailyWeather: dailyWeather, context: privateContext) else { return nil }
        dailyTemperatureCD.populate(dailyTemperature: dailyTemperature, dailyWeather: dailyWeather)
        return dailyTemperatureCD
    }
    
    
    func createDailyWeatherFrom(dailyWeather: DailyWeather, indexId: Int, forecastedWeather: ForecastedWeatherCD) -> DailyWeatherCD? {
        guard
            let dailyWeatherCD = DailyWeatherCD.firstOrCreate(withForecastedWeather: forecastedWeather, withId: indexId, context: privateContext),
            let weather = dailyWeather.weather.at(0),
            let temperatureCD = createDailyTemperatureFrom(dailyTemperature: dailyWeather.temperature, dailyWeather: dailyWeatherCD),
            let weatherCD = createWeatherFrom(weather: weather, dailyWeather: dailyWeatherCD)
        else {
            return nil
        }
        dailyWeatherCD.populate(dailyWeather: dailyWeather, indexId: indexId, forecastedWeather: forecastedWeather, temperature: temperatureCD, weather: weatherCD)
        return dailyWeatherCD
    }
    
    func createForecastedWeatherFrom(forecastedWeather: ForecastedWeather) -> ForecastedWeatherCD? {
        guard let forecastedWeatherCD = ForecastedWeatherCD.firstOrCreate(withLongitude: forecastedWeather.longitude, withLatitude: forecastedWeather.latitude, context: privateContext) else { return nil }
        var dailyWeathers: [DailyWeatherCD] = []
        for (index, dailyWeather) in forecastedWeather.forecastedWeather.enumerated() {
            if let dailyWeatherCD = createDailyWeatherFrom(dailyWeather: dailyWeather, indexId: index, forecastedWeather: forecastedWeatherCD) {
                dailyWeathers.append(dailyWeatherCD)
            }
        }
        forecastedWeatherCD.populate(forecastedWeather: forecastedWeather, dailyWeathers: dailyWeathers)
        return forecastedWeatherCD
    }
    
    //MARK: - Save Changes
    
    func saveChanges() {
        coreDataStack.saveChangesSync(context: privateContext)
        coreDataStack.saveChangesToDisk()
    }
}
