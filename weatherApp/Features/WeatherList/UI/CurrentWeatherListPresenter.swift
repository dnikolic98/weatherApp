//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class CurrentWeatherListPresenter {
    
    private var currentWeatherList: [CurrentWeatherViewModel] = []
    private let weatherRepository: WeatherRepository
    private let navigationService: NavigationService
    
    init(weatherRepository: WeatherRepository, navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
    }
    
    var numberOfCurrentWeather: Int {
        currentWeatherList.count
    }
    
    func fetchCurrentWeatherList(completion: @escaping (([CurrentWeatherViewModel]?) -> Void)) {
        let locationIds = Cities.allCases.map { $0.rawValue }
        
        weatherRepository.fetchSeveralCurrentWeather(id: locationIds) { [weak self] (currentWeatherList) in
            guard
                let self = self,
                let currentWeatherList = currentWeatherList
            else {
                completion(nil)
                return
            }
            
            self.currentWeatherList = currentWeatherList.map { CurrentWeatherViewModel(currentWeather: $0) }
            completion(self.currentWeatherList)
        }
    }
    
    func currentWeather(atIndex index: Int) -> CurrentWeatherViewModel? {
        return currentWeatherList.at(index)
    }
    
    
    func handleSelectedLocation(currentWeather: CurrentWeatherViewModel) {
        navigationService.goToDetailWeather(currentWeather: currentWeather)
    }
    
}
