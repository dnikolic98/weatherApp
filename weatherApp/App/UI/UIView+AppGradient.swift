//
//  BackgroundGradientManager.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setAutomaticGradient(currentWeather: CurrentWeatherViewModel) {
        let currentTime = currentWeather.dayTime
        let sunrise = currentWeather.sunrise
        let sunset = currentWeather.sunset
        
        if currentTime > sunrise && currentTime < sunset {
            setAnimatedGradientBackground(startColor: .darkPurple, endColor: .teal)
        } else {
            setAnimatedGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
        }
    }
    
    func setDefaultGradient() {
        setAnimatedGradientBackground(startColor: .darkPurple, endColor: .darkNavyBlue)
    }
    
}
