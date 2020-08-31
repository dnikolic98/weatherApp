//
//  MainInformationView.swift
//  weatherApp
//
//  Created by Dario Nikolic on 25/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

class MainInformationView: UIView {
    
    private let locationNameLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let updatedInfoLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let temperatureStackView = UIStackView()
    private let lineView = UIView()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         commonInit()
    }
    
    func set(currentWeather: CurrentWeatherViewModel) {
        locationNameLabel.text = currentWeather.name
        weatherDescriptionLabel.text = currentWeather.weatherDescription.firstCapitalized
        currentTempLabel.text = String(format: LocalizedStrings.degreeValueFormat, currentWeather.temperature)
        minTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.minTemperature)
        maxTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.maxTemperature)
        updatedInfoLabel.text = currentWeather.updatedTime
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        styleElements()
        setupLayout()
        
        backgroundColor = .clear
    }
    
    //MARK: - Styling Elements
    
    private func styleElements() {
        styleLocationNameLabel()
        styleWeatherDescriptionLabel()
        styleCurrentTempLabel()
        styleTemperatureStackView()
        styleMinTempLabel()
        styleMaxTempLabel()
        styleLine()
        styleUpdatedInfoLabel()
    }
    
    private func styleLine() {
        lineView.backgroundColor = .white30
    }
    
    private func styleUpdatedInfoLabel() {
        updatedInfoLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        updatedInfoLabel.adjustsFontSizeToFitWidth = true
        updatedInfoLabel.minimumScaleFactor = 0.5
        updatedInfoLabel.textColor = .white
    }
    
    private func styleLocationNameLabel() {
        locationNameLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationNameLabel.minimumScaleFactor = 0.5
        locationNameLabel.textColor = .white
    }
    
    private func styleWeatherDescriptionLabel() {
        weatherDescriptionLabel.font = UIFont.systemFont(ofSize: 30, weight: .thin)
        weatherDescriptionLabel.adjustsFontSizeToFitWidth = true
        weatherDescriptionLabel.minimumScaleFactor = 0.5
        weatherDescriptionLabel.textColor = .white
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func styleCurrentTempLabel() {
        currentTempLabel.font = UIFont.systemFont(ofSize: 150, weight: .thin)
        currentTempLabel.adjustsFontSizeToFitWidth = true
        currentTempLabel.minimumScaleFactor = 0.5
        currentTempLabel.textColor = .white
    }
    
    private func styleTemperatureStackView() {
        temperatureStackView.axis = .vertical
        temperatureStackView.distribution = .fill
        temperatureStackView.alignment = .center
        temperatureStackView.spacing = 5
    }
    
    private func styleMinTempLabel() {
        minTempLabel.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        minTempLabel.adjustsFontSizeToFitWidth = true
        minTempLabel.minimumScaleFactor = 0.5
        minTempLabel.textColor = .white
    }
    
    private func styleMaxTempLabel() {
        maxTempLabel.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        maxTempLabel.adjustsFontSizeToFitWidth = true
        maxTempLabel.minimumScaleFactor = 0.5
        maxTempLabel.textColor = .white
    }
    
    //MARK: - Setting Up Layout
    
    private func setupSubviews() {
        addSubview(locationNameLabel)
        addSubview(weatherDescriptionLabel)
        addSubview(currentTempLabel)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(weatherIcon)
        addSubview(temperatureStackView)
        addSubview(lineView)
        addSubview(updatedInfoLabel)
        
        temperatureStackView.addArrangedSubview(maxTempLabel)
        temperatureStackView.addArrangedSubview(lineView)
        temperatureStackView.addArrangedSubview(minTempLabel)
    }
    
    private func setupLayout() {
        weatherIcon.autoSetDimension(.height, toSize: 50)
        weatherIcon.autoSetDimension(.width, toSize: 50)
        
        lineView.autoSetDimension(.height, toSize: 1)
        
        locationNameLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 25)
        locationNameLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 25)
        locationNameLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -30)
        
        weatherIcon.autoPinEdge(.top, to: .bottom, of: locationNameLabel, withOffset: 10)
        weatherIcon.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20)
        
        weatherDescriptionLabel.autoAlignAxis(.horizontal, toSameAxisOf: weatherIcon)
        weatherDescriptionLabel.autoPinEdge(.leading, to: .trailing, of: weatherIcon, withOffset: 10)
        weatherDescriptionLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -30)
        
        currentTempLabel.autoPinEdge(.top, to: .bottom, of: weatherDescriptionLabel)
        currentTempLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 30, relation: .greaterThanOrEqual)
        
        temperatureStackView.autoAlignAxis(.horizontal, toSameAxisOf: currentTempLabel)
        temperatureStackView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -30)
        temperatureStackView.autoPinEdge(.leading, to: .trailing, of: currentTempLabel, withOffset: 25)
        
        lineView.widthAnchor.constraint(equalTo: maxTempLabel.widthAnchor).isActive = true
        
        updatedInfoLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 5)
        updatedInfoLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -20)
    }
    
}
