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
    private var selectedLocationIds: [Int] = []
    
    init(weatherRepository: WeatherRepository,navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
    }
    
    @objc func handleBackButtonTapped() {
        navigationService.goBack()
    }
    
    func fetchCityList() -> Observable<[CityViewModel]> {
        weatherRepository
        .fetchSelectedLocations()
            .do(onNext: { [weak self] selectedLocations in
                self?.selectedLocationIds = selectedLocations.map({ Int($0.id) })
            })
            .flatMap({ [weak self] _ -> Observable<[CityCoreData]> in
                self?.weatherRepository.fetchCityLists() ?? Observable.of()
            })
            .flatMap({ [weak self] cityCoreData -> Observable<[CityViewModel]> in
                guard let self = self else { return Observable.of() }
                
                let cityViewModels = cityCoreData.map { city -> CityViewModel in
                    let selected = self.selectedLocationIds.contains(Int(city.id))
                    return CityViewModel(city: city, isSelected: selected)
                }
                
                return Observable.of(cityViewModels)
            })
    }
    
    func handleCellTap(city: CityViewModel) {
        weatherRepository.selectLocation(id: city.id)
        navigationService.goBack()
    }
    
}
