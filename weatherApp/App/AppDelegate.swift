//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let appDependencies = AppDependencies()
    var window: UIWindow?
    var navigationController: UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController()
        let navigationService = NavigationService(navigationController: navigationController, appDependencies: appDependencies)
        if let window = window {
            navigationService.presentInWindow(window: window)
        }
        
        return true
    }
    
}

