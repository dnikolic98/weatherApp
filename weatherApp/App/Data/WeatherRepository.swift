//
//  WeatherRepository.swift
//  weatherApp
//
//  Created by Dario Nikolic on 18/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import CoreData
import Reachability
import RxSwift

class WeatherRepository {
    
    let weatherService: WeatherServiceProtocol
    let coreDataService: CoreDataServiceProtocol
    let cityLocationService: CityLocationServiceProtocol
    var reachability: Reachability
    
    init(weatherService: WeatherServiceProtocol, coreDataService: CoreDataServiceProtocol, reachability: Reachability, cityLocationService: CityLocationServiceProtocol) {
        self.weatherService = weatherService
        self.reachability = reachability
        self.coreDataService = coreDataService
        self.cityLocationService = cityLocationService
        
        startReachability()
    }
    
    func fetchSeveralCurrentWeather(id: [Int]) -> Observable<[CurrentWeatherCoreData]> {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCoreData = coreDataService.fetchCurrentWeather()
            return Observable.of(currentWeatherListCoreData)
            
        default:
            return weatherService.fetchSeveralCurrentWeather(id: id)
                .do(onNext: { [weak self] multipleCurrentWeather in
                    guard let self = self else { return }
                    
                    let currentWeatherList = multipleCurrentWeather.list
                    for currentWeather in currentWeatherList {
                        self.coreDataService.createCurrentWeatherFrom(currentWeather: currentWeather)
                    }
                    self.coreDataService.saveChanges()
                })
                .flatMap({ multipleCurrentWeather -> Observable<[CurrentWeatherCoreData]> in
                    let currentWeatherListCoreData = self.coreDataService.fetchCurrentWeather()
                    return Observable.of(currentWeatherListCoreData)
                })
        }
    }
    
    func fetchForcastWeather(coord: Coordinates) -> Observable<ForecastedWeatherCoreData> {
        switch reachability.connection {
        case .unavailable:
            guard let forecastedWeather = coreDataService.fetchForecastWeather(coord: coord) else {
                return Observable.of()
            }
            return Observable.of(forecastedWeather)
            
        default:
            return weatherService.fetchForecastWeather(coord: coord)
                .do(onNext: { [weak self] forecastedWeather in
                    guard let self = self else { return }
                    
                    self.coreDataService.createForecastedWeatherFrom(forecastedWeather: forecastedWeather)
                    self.coreDataService.saveChanges()
                })
                .flatMap({ [weak self] forecastedWeather -> Observable<ForecastedWeatherCoreData> in
                    guard
                        let self = self,
                        let forecastedWeather = self.coreDataService.fetchForecastWeather(coord: coord)
                    else {
                        return Observable.of()
                    }
                    
                    return Observable.of(forecastedWeather)
                })
        }
    }
    
    func fetchCurrentWeather(coord: Coordinates) -> Observable<CurrentWeatherCoreData> {
        switch reachability.connection {
        case .unavailable:
            guard let currentWeather = coreDataService.fetchCurrentWeather(coord: coord) else {
                return Observable.of()
            }
            return Observable.of(currentWeather)
            
        default:
            return weatherService.fetchCurrentWeather(coord: coord)
                .do(onNext: { [weak self] currentWeather in
                    guard let self = self else { return }
                    
                    self.coreDataService.createCurrentWeatherFrom(currentWeather: currentWeather)
                    self.coreDataService.saveChanges()
                })
                .flatMap({ [weak self] currentWeather -> Observable<CurrentWeatherCoreData> in
                    guard
                        let self = self,
                        let currentWeather = self.coreDataService.fetchCurrentWeather(coord: coord)
                    else {
                        return Observable.of()
                    }
                    
                    return Observable.of(currentWeather)
                })
        }
    }
    
    func fetchCities() -> Observable<[City]> {
        return cityLocationService.cityList
    }
    
    private func startReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}
