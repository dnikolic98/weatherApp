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
            setGradientBackground(startColor: .darkPurple, endColor: .teal)
        } else {
            setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
        }
    }
    
    func setDefaultGradient() {
        setGradientBackground(startColor: .darkPurple, endColor: .darkNavyBlue)
    }
    
}
