//
//  CoreDataService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 24/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData
import RxSwift

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
    
    func fetchCurrentWeather(id: [Int]) -> Observable<[CurrentWeatherCoreData]> {
        let request: NSFetchRequest<CurrentWeatherCoreData> = CurrentWeatherCoreData.fetchRequest()
        request.predicate = Predicates.severalIdPredicate(id)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return mainContext.rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap { fetchedManagedObject -> Observable<[CurrentWeatherCoreData]> in
                guard let fetchedCurrentWeather = fetchedManagedObject as? [CurrentWeatherCoreData] else { return .just([]) }
                return .just(fetchedCurrentWeather)
        }
    }
    
    func fetchCurrentWeather(coord: Coordinates) -> Observable<CurrentWeatherCoreData?> {
        let request: NSFetchRequest<CurrentWeatherCoreData> = CurrentWeatherCoreData.fetchRequest()
        request.predicate = Predicates.coordinatesPredicate(coord, epsilon: 0.01, keyPath: "coord")
        request.sortDescriptors = []
        
        return mainContext.rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap { fetchedManagedObject -> Observable<CurrentWeatherCoreData?> in
                guard let fetchedCurrentWeather = fetchedManagedObject.first as? CurrentWeatherCoreData else { return .just(nil) }
                return .just(fetchedCurrentWeather)
        }
    }
    
    func fetchForecastWeather(coord: Coordinates) -> Observable<ForecastedWeatherCoreData?> {
        let request: NSFetchRequest<ForecastedWeatherCoreData> = ForecastedWeatherCoreData.fetchRequest()
        request.predicate = Predicates.coordinatesPredicate(coord)
        request.sortDescriptors = []
        
        return mainContext.rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap { fetchedManagedObject -> Observable<ForecastedWeatherCoreData?> in
                guard let fetchedForecastWeather = fetchedManagedObject.first as? ForecastedWeatherCoreData else { return .just(nil) }
                return .just(fetchedForecastWeather)
        }
    }
    
    func fetchCityList(query: String) -> Observable<[CityCoreData]> {
        let request: NSFetchRequest<CityCoreData> = CityCoreData.fetchRequest()
        request.predicate = Predicates.beginsWithNamePredicate(query)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return mainContext.rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap { fetchedManagedObject -> Observable<[CityCoreData]> in
                guard let fetchedCity = fetchedManagedObject as? [CityCoreData] else { return .just([]) }
                return .just(fetchedCity)
        }
    }
    
    func fetchSelectedLocations() -> Observable<[SelectedLocationCoreData]> {
        let request: NSFetchRequest<SelectedLocationCoreData> = SelectedLocationCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        return mainContext.rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap { fetchedManagedObject -> Observable<[SelectedLocationCoreData]> in
                guard let fetchedSelectedLocation = fetchedManagedObject as? [SelectedLocationCoreData] else { return .just([]) }
                return .just(fetchedSelectedLocation)
        }
    }
    
    //MARK: - Create CoreData Models
    
    @discardableResult
    func createWeatherFrom(weather: Weather, currentWeather: CurrentWeatherCoreData) -> WeatherCoreData? {
        guard let weatherCoreData = WeatherCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        weatherCoreData.populate(weather: weather, currentWeather: currentWeather)
        return weatherCoreData
    }
    
    @discardableResult
    func createWeatherFrom(weather: Weather, dailyWeather: DailyWeatherCoreData) -> WeatherCoreData? {
        guard let weatherCoreData = WeatherCoreData.firstOrCreate(withDailyWeather: dailyWeather, context: privateContext) else { return nil }
        weatherCoreData.populate(weather: weather, dailyWeather: dailyWeather)
        return weatherCoreData
    }
    
    @discardableResult
    func createWindFrom(wind: Wind, currentWeather: CurrentWeatherCoreData) -> WindCoreData? {
        guard let windCoreData = WindCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        windCoreData.populate(wind: wind, currentWeather: currentWeather)
        return windCoreData
    }
    
    @discardableResult
    func createForecastFrom(forecast: Forecast, currentWeather: CurrentWeatherCoreData) -> ForecastCoreData? {
        guard let forecastCoreData = ForecastCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        forecastCoreData.populate(forecast: forecast, currentWeather: currentWeather)
        return forecastCoreData
    }
    
    @discardableResult
    func createCoordinatesFrom(coordinates: Coordinates, currentWeather: CurrentWeatherCoreData) -> CoordinatesCoreData? {
        guard let coordinatesCoreData = CoordinatesCoreData.firstOrCreate(withCurrentWeather: currentWeather, context: privateContext) else { return nil }
        coordinatesCoreData.populate(coordinates: coordinates, currentWeather: currentWeather)
        return coordinatesCoreData
    }
    
    @discardableResult
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
    
    @discardableResult
    func createDailyTemperatureFrom(dailyTemperature: DailyTemperature, dailyWeather: DailyWeatherCoreData) -> DailyTemperatureCoreData? {
        guard let dailyTemperatureCoreData = DailyTemperatureCoreData.firstOrCreate(withDailyWeather: dailyWeather, context: privateContext) else { return nil }
        dailyTemperatureCoreData.populate(dailyTemperature: dailyTemperature, dailyWeather: dailyWeather)
        return dailyTemperatureCoreData
    }
    
    @discardableResult
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
    
    @discardableResult
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
    
    @discardableResult
    func createSelectedLocationFrom(id: Int) -> SelectedLocationCoreData? {
        guard let selectedLocation = SelectedLocationCoreData.firstOrCreate(withId: id, context: privateContext) else { return nil }
        selectedLocation.populate(id: id)
        return selectedLocation
    }
    
    //MARK - Remove Core data models
    
    func removeSelectedLocation(id: Int) {
        guard let location = fetchSelectedLocations(id: id) else { return }
        mainContext.delete(location)
        saveChanges()
    }
    
    //MARK: - Save Changes
    
    func saveChanges() {
        coreDataStack.saveChangesSync(context: privateContext)
        coreDataStack.saveChangesToDisk()
    }
    
    //MARK: - Helpers
    
    private func fetchSelectedLocations(id: Int) -> SelectedLocationCoreData? {
        let request: NSFetchRequest<SelectedLocationCoreData> = SelectedLocationCoreData.fetchRequest()
        request.predicate = Predicates.idPredicate(id)
        
        let location = try? mainContext.fetch(request)
        return location?.first
    }
    
}
