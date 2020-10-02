//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift
import RxCocoa

class WeatherListPresenter {
    
    //MARK: - Properties
    
    private var currentWeatherList: [CurrentWeatherViewModel] = []
    private let weatherRepository: WeatherRepository
    private let navigationService: NavigationService
    private let locationService: LocationServiceProtocol
    private var currentLocation: BehaviorRelay<Coordinates>
    private var locationDisposeBag: DisposeBag = DisposeBag()
    
    var currentLocationWeather: CurrentWeatherViewModel?
    var isReachable: Observable<Bool> {
        weatherRepository.isReachable.skip(1)
    }
    var areLocationsAllowed: Bool {
        locationService.checkLocationServicesAuthorization()
    }
    var areLocationsEnabled: Observable<Bool> {
        locationService.isEnabled
    }
    var currentWeatherData: Observable<([CurrentWeatherViewModel], CurrentWeatherViewModel?)> {
        Observable.combineLatest(
            fetchCurrentWeatherList(),
            fetchCurrenLocationtWeather())
    }
    var numberOfCurrentWeather: Int {
        currentWeatherList.count
    }
    
    //MARK: - Initialization
    
    init(weatherRepository: WeatherRepository, locationService: LocationServiceProtocol, navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
        self.locationService = locationService
        self.currentLocation = BehaviorRelay<Coordinates>(value: Coordinates(latitude: 0, longitude: 0))
        
        bindCurrentLocation()
    }
    
    //MARK: - Retrieve currentWeather at index
    
    func currentWeather(atIndex index: Int) -> CurrentWeatherViewModel? {
        return currentWeatherList.at(index)
    }
    
    //MARK: - Handle cell selection action
    
    func handleSelectedLocation(currentWeather: CurrentWeatherViewModel) {
        navigationService.goToDetailWeather(currentWeather: currentWeather)
    }
    
    //MARK: - Handle add location button action
    
    func handleAddLocation() {
        navigationService.goToSearchLocation()
    }
    
    //MARK: - Handle cell remove action
    
    func handleRemoveLocation(id: Int) {
        weatherRepository.deselectLocation(id: id)
    }
    
    //MARK: - ViewModel fetching
    
    private func fetchCurrenLocationtWeather() -> Observable<CurrentWeatherViewModel?> {
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
    
    private func fetchCurrentWeatherList() -> Observable<[CurrentWeatherViewModel]> {
        weatherRepository
            .fetchSelectedLocations()
            .flatMap { [weak self] selectedLocation -> Observable<[CurrentWeatherCoreData]> in
                guard let self = self else { return .just([]) }
                let locationIds = selectedLocation.map { Int($0.id) }
                return self.weatherRepository.fetchSeveralCurrentWeather(id: locationIds)
            }
            .flatMap { currentWeatherCoreData -> Observable<[CurrentWeatherViewModel]> in
                let currentWeatherViewModels = currentWeatherCoreData
                    .map { CurrentWeatherViewModel(currentWeather: $0) }
                    .sorted { $0.name < $1.name }
                return .just(currentWeatherViewModels)
            }
            .do(onNext: { [weak self] currentWeatherViewModels in
                guard let self = self else { return }
                self.currentWeatherList = currentWeatherViewModels
            })
    }
    
    //MARK: - Bind current location to behavior relay
    
    private func bindCurrentLocation() {
        locationService
            .location
            .bind(to: currentLocation)
            .disposed(by: locationDisposeBag)
    }
    
}
