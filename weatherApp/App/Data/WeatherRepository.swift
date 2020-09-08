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
    var reachability: Reachability
    
    init(weatherService: WeatherServiceProtocol, coreDataService: CoreDataServiceProtocol, reachability: Reachability) {
        self.weatherService = weatherService
        self.reachability = reachability
        self.coreDataService = coreDataService
        
        startReachability()
    }
    
    func fetchSeveralCurrentWeather(id: [Int]) -> Observable<[CurrentWeatherCoreData]> {
        switch reachability.connection {
        case .unavailable:
            let currentWeatherListCoreData = coreDataService.fetchCurrentWeather()
            return .just(currentWeatherListCoreData)
            
        default:
            return weatherService.fetchSeveralCurrentWeather(id: id)
                .do(onNext: { [weak self] multipleCurrentWeather in
                    guard let self = self else { return }
                    self.createAndSaveCurrentWeather(from: multipleCurrentWeather)
                })
                .flatMap({ multipleCurrentWeather -> Observable<[CurrentWeatherCoreData]> in
                    let currentWeatherListCoreData = self.coreDataService.fetchCurrentWeather()
                    return .just(currentWeatherListCoreData)
                })
        }
    }
    
    func fetchForcastWeather(coord: Coordinates) -> Observable<ForecastedWeatherCoreData> {
        switch reachability.connection {
        case .unavailable:
            guard let forecastedWeather = coreDataService.fetchForecastWeather(coord: coord) else {
                return Observable.of()
            }
            return .just(forecastedWeather)
            
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
                    
                    return .just(forecastedWeather)
                })
        }
    }
    
    func fetchCurrentWeather(coord: Coordinates) -> Observable<CurrentWeatherCoreData> {
        switch reachability.connection {
        case .unavailable:
            guard let currentWeather = coreDataService.fetchCurrentWeather(coord: coord) else {
                return Observable.of()
            }
            return .just(currentWeather)
            
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
                    
                    return .just(currentWeather)
                })
        }
    }
    
    private func createAndSaveCurrentWeather(from multipleCurrentWeather: MultipleCurrentWeather) {
        let currentWeatherList = multipleCurrentWeather.list
        for currentWeather in currentWeatherList {
            self.coreDataService.createCurrentWeatherFrom(currentWeather: currentWeather)
        }
        self.coreDataService.saveChanges()
    }
    
    private func startReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}
