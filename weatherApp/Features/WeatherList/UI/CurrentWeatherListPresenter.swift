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
    private var currentLocationWeather: CurrentWeatherViewModel?
    private let weatherRepository: WeatherRepository
    private let navigationService: NavigationService
    private let locationService: LocationService
    private var currentLocation: BehaviorRelay<Coordinates>
    private var locationDisposeBag: DisposeBag = DisposeBag()
    
    init(weatherRepository: WeatherRepository, locationService: LocationService, navigationService: NavigationService) {
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
        let locationIds = Cities.allCases.map { $0.rawValue }
        
        return weatherRepository.fetchSeveralCurrentWeather(id: locationIds)
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
    }
    
    func currentWeather(atIndex index: Int) -> CurrentWeatherViewModel? {
        return currentWeatherList.at(index)
    }
    
    func handleSelectedLocation(currentWeather: CurrentWeatherViewModel) {
        navigationService.goToDetailWeather(currentWeather: currentWeather)
    }
    
    private func bindCurrentLocation() {
        locationService
            .location
            .bind(to: currentLocation)
            .disposed(by: locationDisposeBag)
    }
    
}
