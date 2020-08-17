//
//  NavigationService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 17/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class NavigationService {
    
    private let appDependencies = AppDependencies()
    private let navigationController = UINavigationController()
    private var window: UIWindow!
    
    init(window: UIWindow) {
        presentInWindow(window: window)
        pushHomeViewController()
    }
    
    func pushHomeViewController() {
        let presenter = CurrentWeatherListPresenter(weatherService: appDependencies.weatherService, navigationService: self)
        navigationController.pushViewController(HomeViewController(currentWeatherListPresenter: presenter), animated: true)
    }
    
    func pushDetailWeatherViewController(currentWeather: CurrentWeatherViewModel) {
        let presenter = DetailWeatherPresenter(currentWeather: currentWeather, weatherService: appDependencies.weatherService, navigationService: self)
        navigationController.pushViewController(DetailWeatherViewController(detailWeatherPresenter: presenter), animated: true)
    }
    
    private func presentInWindow(window: UIWindow){
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}

