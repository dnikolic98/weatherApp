//
//  MainInformationView.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class MainInformationView: UIView {
    
    var locationNameLabel: UILabel!
    var weatherDescriptionLabel: UILabel!
    var currentTempLabel: UILabel!
    var minTempLabel: UILabel!
    var lineView: UIView!
    var maxTempLabel: UILabel!
    var weatherIcon: UIImageView!
    var temperatureStackView: UIStackView!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         buildViews()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         buildViews()
    }
    
    func set(currentWeather: CurrentWeatherViewModel) {
        locationNameLabel.text = currentWeather.name
        weatherDescriptionLabel.text = currentWeather.weatherDescription
        currentTempLabel.text = String(format: LocalizedStrings.degreeValueFormat, currentWeather.temperature)
        minTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.minTemperature)
        maxTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.maxTemperature)
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
}
