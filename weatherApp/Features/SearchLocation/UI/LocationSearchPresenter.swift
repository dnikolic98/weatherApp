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
    
    init(weatherRepository: WeatherRepository,navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
    }
    
    @objc func handleBackButtonTapped() {
        navigationService.goBack()
    }
    
}
