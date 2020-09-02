//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class CurrentWeatherListPresenter {
    
    private var currentWeatherList: [CurrentWeatherViewModel] = []
    private var currentLocationWeather: CurrentWeatherViewModel?
    private let weatherRepository: WeatherRepository
    private let navigationService: NavigationService
    private let locationService: LocationService
    
    init(weatherRepository: WeatherRepository, locationService: LocationService, navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
        self.locationService = locationService
    }
    
    var numberOfCurrentWeather: Int {
        currentWeatherList.count
    }
    
    func fetchCurrentWeatherList(completion: @escaping (([CurrentWeatherViewModel]) -> Void)) {
        let locationIds = Cities.allCases.map { $0.rawValue }
        
        weatherRepository.fetchSeveralCurrentWeather(id: locationIds) { [weak self] (currentWeatherList) in
            guard
                let self = self,
                !currentWeatherList.isEmpty
            else {
                completion([])
                return
            }
            
            self.currentWeatherList = currentWeatherList.map { CurrentWeatherViewModel(currentWeather: $0) }
            completion(self.currentWeatherList)
        }
    }
    
    func fetchCurrentWeather(completion: @escaping ((CurrentWeatherViewModel?) -> Void)) {
        locationService.getLocation { [weak self] (coordinates, error) -> (Void) in
            guard
                let self = self,
                let coord = coordinates
            else {
                completion(nil)
                return
            }
            
            self.weatherRepository.fetchCurrentWeather(coord: coord) { [weak self] (currentWeather) in
                guard
                    let self = self,
                    let currentWeather = currentWeather
                else {
                    completion(nil)
                    return
                }
                
                self.currentLocationWeather = CurrentWeatherViewModel(currentWeather: currentWeather)
                completion(self.currentLocationWeather)
            }
        }
    }
    
    func currentWeather(atIndex index: Int) -> CurrentWeatherViewModel? {
        return currentWeatherList.at(index)
    }
    
    func handleSelectedLocation(currentWeather: CurrentWeatherViewModel) {
        navigationService.goToDetailWeather(currentWeather: currentWeather)
    }
    
}
