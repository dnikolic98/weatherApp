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
import RxCocoa
import RxReachability

class WeatherRepository {
    
    var reachabilityDisposeBag: DisposeBag = DisposeBag()
    let weatherService: WeatherServiceProtocol
    let coreDataService: CoreDataServiceProtocol
    var reachability: Reachability
    var isReachable: BehaviorRelay<Bool>
    
    init(weatherService: WeatherServiceProtocol, coreDataService: CoreDataServiceProtocol, reachability: Reachability) {
        self.weatherService = weatherService
        self.reachability = reachability
        self.coreDataService = coreDataService
        self.isReachable = BehaviorRelay<Bool>(value: false)
        
        startReachability()
        bindReachability()
    }
    
    func fetchSeveralCurrentWeather(id: [Int]) -> Observable<[CurrentWeatherCoreData]> {
        switch reachability.connection {
        case .none:
            let currentWeatherListCoreData = coreDataService.fetchCurrentWeather(id: id)
            return .just(currentWeatherListCoreData)
            
        default:
            return weatherService.fetchSeveralCurrentWeather(id: id)
                .do(onNext: { [weak self] multipleCurrentWeather in
                    guard let self = self else { return }
                    self.createAndSaveCurrentWeather(from: multipleCurrentWeather)
                })
                .flatMap { multipleCurrentWeather -> Observable<[CurrentWeatherCoreData]> in
                    let currentWeatherListCoreData = self.coreDataService.fetchCurrentWeather(id: id)
                    return .just(currentWeatherListCoreData)
                }
        }
    }
    
    func fetchForcastWeather(coord: Coordinates) -> Observable<ForecastedWeatherCoreData?> {
        switch reachability.connection {
        case .none:
            guard let forecastedWeather = coreDataService.fetchForecastWeather(coord: coord) else {
                return .just(nil)
            }
            return .just(forecastedWeather)
            
        default:
            return weatherService.fetchForecastWeather(coord: coord)
                .do(onNext: { [weak self] forecastedWeather in
                    guard let self = self else { return }
                    
                    self.coreDataService.createForecastedWeatherFrom(forecastedWeather: forecastedWeather)
                    self.coreDataService.saveChanges()
                })
                .flatMap { [weak self] forecastedWeather -> Observable<ForecastedWeatherCoreData?> in
                    guard
                        let self = self,
                        let forecastedWeather = self.coreDataService.fetchForecastWeather(coord: coord)
                    else {
                        return .just(nil)
                    }
                    
                    return .just(forecastedWeather)
                }
        }
    }
    
    func fetchCurrentWeather(coord: Coordinates) -> Observable<CurrentWeatherCoreData?> {
        switch reachability.connection {
        case .none:
            guard let currentWeather = coreDataService.fetchCurrentWeather(coord: coord) else {
                return .just(nil)
            }
            return .just(currentWeather)
            
        default:
            return weatherService.fetchCurrentWeather(coord: coord)
                .do(onNext: { [weak self] currentWeather in
                    guard let self = self else { return }
                    
                    self.coreDataService.createCurrentWeatherFrom(currentWeather: currentWeather)
                    self.coreDataService.saveChanges()
                })
                .flatMap { [weak self] currentWeather -> Observable<CurrentWeatherCoreData?> in
                    guard
                        let self = self,
                        let currentWeather = self.coreDataService.fetchCurrentWeather(coord: coord)
                    else {
                        return .just(nil)
                    }
                    
                    return .just(currentWeather)
                }
        }
    }
    
    private func createAndSaveCurrentWeather(from multipleCurrentWeather: MultipleCurrentWeather) {
        let currentWeatherList = multipleCurrentWeather.list
        for currentWeather in currentWeatherList {
            self.coreDataService.createCurrentWeatherFrom(currentWeather: currentWeather)
        }
        self.coreDataService.saveChanges()
    }
    
    func fetchCityLists(query: String) -> Observable<[CityCoreData]> {
        let cityList = coreDataService.fetchCityList(query: query)
        return .just(cityList)
    }
    
    func fetchSelectedLocations() -> Observable<[SelectedLocationCoreData]> {
        let selectedLocations = coreDataService.fetchSelectedLocations()
        return .just(selectedLocations)
    }
    
    func selectLocation(id: Int) {
        coreDataService.createSelectedLocationFrom(id: id)
        coreDataService.saveChanges()
    }
    
    func deselectLocation(id: Int) {
        coreDataService.removeSelectedLocation(id: id)
    }
    
    private func startReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func bindReachability() {
        Reachability.rx
            .isReachable
            .bind(to: isReachable)
            .disposed(by: reachabilityDisposeBag)
    }
    
}
