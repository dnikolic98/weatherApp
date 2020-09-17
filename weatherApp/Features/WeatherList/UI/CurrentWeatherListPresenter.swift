//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift
import RxCocoa

class CurrentWeatherListPresenter {
    
    private var currentWeatherList: [CurrentWeatherViewModel] = []
    private let weatherRepository: WeatherRepository
    private let navigationService: NavigationService
    private let locationService: LocationServiceProtocol
    private var currentLocation: BehaviorRelay<Coordinates>
    private var locationDisposeBag: DisposeBag = DisposeBag()
    
    var currentLocationWeather: CurrentWeatherViewModel?
    var currentWeatherData: Observable<([CurrentWeatherViewModel], CurrentWeatherViewModel?)> {
       Observable.combineLatest(
          fetchCurrentWeatherList(),
          fetchCurrenLocationtWeather())
    }
    
    init(weatherRepository: WeatherRepository, locationService: LocationServiceProtocol, navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
        self.locationService = locationService
        self.currentLocation = BehaviorRelay<Coordinates>(value: Coordinates(latitude: 0, longitude: 0))
        
        bindCurrentLocation()
    }
    
    var numberOfCurrentWeather: Int {
        currentWeatherList.count
    }
    
    func fetchCurrentWeatherList() -> Observable<[CurrentWeatherViewModel]> {
        weatherRepository
            .fetchSelectedLocations()
            .flatMap { [weak self] selectedLocation -> Observable<[CurrentWeatherCoreData]> in
                guard let self = self else { return .just([]) }
                let locationIds = selectedLocation.map { Int($0.id) }
                return self.weatherRepository.fetchSeveralCurrentWeather(id: locationIds)
            }
            .flatMap { currentWeatherCoreData -> Observable<[CurrentWeatherViewModel]> in
                let currentWeatherViewModels = currentWeatherCoreData.map { CurrentWeatherViewModel(currentWeather: $0) }
                return .just(currentWeatherViewModels)
            }
            .do(onNext: { [weak self] currentWeatherViewModels in
                guard let self = self else { return }
                self.currentWeatherList = currentWeatherViewModels
            })
    }
    
    func fetchCurrenLocationtWeather() -> Observable<CurrentWeatherViewModel?> {
        return currentLocation
            .asObservable()
            .flatMap { [weak self] coord -> Observable<CurrentWeatherCoreData?> in
                guard let self = self else { return .empty() }
                return self.weatherRepository.fetchCurrentWeather(coord: coord)
            }
            .flatMap { currentWeather -> Observable<CurrentWeatherViewModel?> in
                guard let currentWeather = currentWeather else { return .just(nil) }
                let currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: currentWeather)
                return .just(currentWeatherViewModel)
            }
            .do(onNext: { [weak self] currentWeather in
                self?.currentLocationWeather = currentWeather
            })
    }
    
    func isReachable() -> Observable<Bool> {
        weatherRepository.isReachable
    }
    
    func checkLocationsAllowed() -> Bool {
        locationService.checkLocationServicesAuthorization()
    }
    
    func areLocationsEnabled() -> Observable<Bool> {
        locationService.isEnabled
    }
    
    func currentWeather(atIndex index: Int) -> CurrentWeatherViewModel? {
        return currentWeatherList.at(index)
    }
    
    func handleSelectedLocation(currentWeather: CurrentWeatherViewModel) {
        navigationService.goToDetailWeather(currentWeather: currentWeather)
    }
    
    func handleAddLocation(assignDelegate: LocationSearchDelegate) {
        navigationService.goToSearchLocation(delegate: assignDelegate)
    }
    
    func handleRemoveLocation(id: Int, index: Int) {
        currentWeatherList.remove(at: index)
        weatherRepository.deselectLocation(id: id)
    }
    
    private func bindCurrentLocation() {
        locationService
            .location
            .bind(to: currentLocation)
            .disposed(by: locationDisposeBag)
    }
    
}
