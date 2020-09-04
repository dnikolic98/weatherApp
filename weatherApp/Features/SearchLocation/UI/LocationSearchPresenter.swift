//
//  LocationSearchPresenter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift
import RxCocoa

class LocationSearchPresenter {
    
    private let cityListdisposeBag: DisposeBag = DisposeBag()
    private let weatherRepository: WeatherRepository
    private let navigationService: NavigationService
    private var cityList: BehaviorRelay<[City]>
    
    init(weatherRepository: WeatherRepository,navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
        self.cityList = BehaviorRelay<[City]>(value: [])
        
        bindCityList()
    }
    
    func queryLocationSearch(with query: String) {
        
    }
    
    private func bindCityList() {
        weatherRepository.fetchCities()
        .bind(to: cityList)
        .disposed(by: cityListdisposeBag)
    }
    
}
