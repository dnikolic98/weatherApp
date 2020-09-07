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
            .flatMap({ [weak self] selectedLocation -> Observable<[CurrentWeatherCoreData]> in
                guard let self = self else { return Observable.of() }
                let locationIds = selectedLocation.map { Int($0.id) }
                return self.weatherRepository.fetchSeveralCurrentWeather(id: locationIds)
            })
            .flatMap({ currentWeatherCoreData -> Observable<[CurrentWeatherViewModel]> in
                let currentWeatherViewModels = currentWeatherCoreData.map { CurrentWeatherViewModel(currentWeather: $0) }
                return Observable.of(currentWeatherViewModels)
            })
            .do(onNext: { [weak self] currentWeatherViewModels in
                guard let self = self else { return }
                self.currentWeatherList = currentWeatherViewModels
            })
    }
    
    func fetchCurrenLocationtWeather() -> Observable<CurrentWeatherViewModel> {
        return currentLocation
            .asObservable()
            .flatMap({ [weak self] coord -> Observable<CurrentWeatherCoreData> in
                guard let self = self else { return Observable.of() }
                return self.weatherRepository.fetchCurrentWeather(coord: coord)
            })
            .flatMap({ currentWeather -> Observable<CurrentWeatherViewModel> in
                let currentWeatherViewModel = CurrentWeatherViewModel(currentWeather: currentWeather)
                return Observable.of(currentWeatherViewModel)
            })
            .do(onNext: { [weak self] currentWeather in
                guard let self = self else { return }
                self.currentLocationWeather = currentWeather
            })
    }
    
    func currentWeather(atIndex index: Int) -> CurrentWeatherViewModel? {
        return currentWeatherList.at(index)
    }
    
    func handleSelectedLocation(currentWeather: CurrentWeatherViewModel) {
        navigationService.goToDetailWeather(currentWeather: currentWeather)
    }
    
    func handleAddLocation() {
        navigationService.goToSearchLocation()
    }
    
    private func bindCurrentLocation() {
        locationService
            .location
            .bind(to: currentLocation)
            .disposed(by: locationDisposeBag)
    }
    
}
