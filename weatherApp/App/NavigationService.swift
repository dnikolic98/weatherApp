//
//  NavigationService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 17/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class NavigationService {
    
    private let appDependencies: AppDependencies
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func presentInWindow(window: UIWindow){
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        goToHome()
    }
    
    func goToHome() {
        let presenter = CurrentWeatherListPresenter(weatherRepository: appDependencies.weatherRepository, locationService: appDependencies.locationService, navigationService: self)
        navigationController?.pushViewController(HomeViewController(currentWeatherListPresenter: presenter), animated: true)
    }
    
    func goToDetailWeather(currentWeather: CurrentWeatherViewModel) {
        let presenter = DetailWeatherPresenter(currentWeather: currentWeather, weatherRepository: appDependencies.weatherRepository)
        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        navigationController?.pushViewController(DetailWeatherViewController(detailWeatherPresenter: presenter), animated: true)
    }
    
    func goToSearchLocation() {
        let presenter = LocationSearchPresenter(weatherRepository: appDependencies.weatherRepository, navigationService: self)
        let viewController = LocationSearchViewController(with: presenter)
        navigationController?.heroNavigationAnimationType = .cover(direction: .up)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goBack() {
        navigationController?.heroNavigationAnimationType = .fade
        navigationController?.popViewController(animated: true)
    }

}

