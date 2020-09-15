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
    
    //MARK: - Properties
    
    private let weatherRepository: WeatherRepository
    private let navigationService: NavigationService
    private var selectedLocationIds: [Int] = []
    private var dataSourceData: [CityViewModel] = []
    
    //MARK: - Initialization
    
    init(weatherRepository: WeatherRepository, navigationService: NavigationService) {
        self.weatherRepository = weatherRepository
        self.navigationService = navigationService
    }
    
    //MARK: - Fetching ViewModel
    
    func fetchCityList(query: String) -> Observable<[SectionOfCityViewModels]> {
        weatherRepository
            .fetchSelectedLocations()
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] selectedLocations in
                self?.selectedLocationIds = selectedLocations.map { Int($0.id) }
            })
            .flatMap { [weak self] _ -> Observable<[CityCoreData]> in
                self?.weatherRepository.fetchCityLists(query: query) ?? .just([])
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { [weak self] cityCoreData -> Observable<[CityViewModel]> in
                guard let self = self else { return .just([]) }
                
                let cityViewModels = cityCoreData.map { city -> CityViewModel in
                    let selected = self.selectedLocationIds.contains(Int(city.id))
                    return CityViewModel(city: city, isSelected: selected)
                }
                
                return .just(cityViewModels)
            }
            .do(onNext: { [weak self] cityViewModels in
                self?.dataSourceData = cityViewModels
            })
            .map { [SectionOfCityViewModels(items: $0)] }
    }
    
    //MARK: - Back button action
    
    @objc func handleBackButtonTapped() {
        navigationService.goBack()
    }
    
    //MARK: - Cell select action
    
    func handleCellTap(index: Int) {
        guard let city = dataSourceData.at(index) else { return }
        weatherRepository.selectLocation(id: city.id)
        navigationService.goBack()
    }
    
}
