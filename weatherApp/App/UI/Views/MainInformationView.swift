//
//  MainInformationView.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Hero

class MainInformationView: UIView {
    
    //MARK: - Properties
    
    var locationNameLabel: UILabel!
    var weatherDescriptionLabel: UILabel!
    var currentTempLabel: UILabel!
    var minTempLabel: UILabel!
    var lineView: UIView!
    var maxTempLabel: UILabel!
    var weatherIcon: UIImageView!
    var temperatureStackView: UIStackView!
    var updatedInfoLabel: UILabel!
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    //MARK: - Public Methods
    
    func set(currentWeather: CurrentWeatherViewModel) {
        locationNameLabel.text = currentWeather.name
        weatherDescriptionLabel.text = currentWeather.weatherDescription.firstCapitalized
        currentTempLabel.text = String(format: LocalizedStrings.degreeValueFormat, currentWeather.temperature)
        minTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.minTemperature)
        maxTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.maxTemperature)
        updatedInfoLabel.text = currentWeather.updatedTime
        setupHero(currentWeather: currentWeather)
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    //MARK: - Helpers
    
    private func setupHero(currentWeather: CurrentWeatherViewModel) {
        hero.id = "\(currentWeather.id)"
        locationNameLabel.hero.modifiers = [.fade]
        weatherIcon.hero.modifiers = [.fade]
        currentTempLabel.hero.modifiers = [.fade]
        weatherDescriptionLabel.hero.modifiers = [.fade]
    }
    
}
