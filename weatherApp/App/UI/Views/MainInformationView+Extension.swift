//
//  MainInformationView+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

extension MainInformationView: DesignProtocol {
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        weatherIcon = UIImageView()
        addSubview(weatherIcon)
        
        locationNameLabel = UILabel()
        addSubview(locationNameLabel)
        
        weatherDescriptionLabel = UILabel()
        addSubview(weatherDescriptionLabel)
        
        currentTempLabel = UILabel()
        addSubview(currentTempLabel)
        
        temperatureStackView = UIStackView()
        addSubview(temperatureStackView)
        
        maxTempLabel = UILabel()
        addSubview(maxTempLabel)
        temperatureStackView.addArrangedSubview(maxTempLabel)
        
        lineView = UIView()
        addSubview(lineView)
        temperatureStackView.addArrangedSubview(lineView)
        
        minTempLabel = UILabel()
        addSubview(minTempLabel)
        temperatureStackView.addArrangedSubview(minTempLabel)
        
        updatedInfoLabel = UILabel()
        addSubview(updatedInfoLabel)
    }
    
    func styleViews() {
        styleView()
        styleLocationNameLabel()
        styleWeatherDescriptionLabel()
        styleCurrentTempLabel()
        styleTemperatureStackView()
        styleMaxTempLabel()
        styleLine()
        styleMinTempLabel()
        styleUpdatedInfoLabel()
    }
    
    func defineLayoutForViews() {
        weatherIcon.autoSetDimension(.height, toSize: 50)
        weatherIcon.autoSetDimension(.width, toSize: 50)
        
        lineView.autoSetDimension(.height, toSize: 1)
        
        locationNameLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 10)
        locationNameLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 25)
        
        weatherIcon.autoPinEdge(.top, to: .bottom, of: locationNameLabel, withOffset: 10)
        weatherIcon.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20)
        
        weatherDescriptionLabel.autoAlignAxis(.horizontal, toSameAxisOf: weatherIcon)
        weatherDescriptionLabel.autoPinEdge(.leading, to: .trailing, of: weatherIcon, withOffset: 15)
        weatherDescriptionLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -15)
        
        currentTempLabel.autoPinEdge(.top, to: .bottom, of: weatherDescriptionLabel)
        currentTempLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 30, relation: .greaterThanOrEqual)
        
        temperatureStackView.autoAlignAxis(.horizontal, toSameAxisOf: currentTempLabel)
        temperatureStackView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -30)
        temperatureStackView.autoPinEdge(.leading, to: .trailing, of: currentTempLabel, withOffset: 25)
        
        lineView.widthAnchor.constraint(equalTo: maxTempLabel.widthAnchor).isActive = true
        
        updatedInfoLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -10)
        updatedInfoLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -20)
    }
    
    
    //MARK: - Styling Elements
    
    private func styleView() {
        backgroundColor = .white15
        layer.cornerRadius = 15
    }
    
    private func styleLine() {
        lineView.backgroundColor = .white80
    }
    
    private func styleLocationNameLabel() {
        locationNameLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationNameLabel.minimumScaleFactor = 0.5
        locationNameLabel.textColor = .white
    }
    
    private func styleWeatherDescriptionLabel() {
        weatherDescriptionLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
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
        minTempLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        minTempLabel.adjustsFontSizeToFitWidth = true
        minTempLabel.minimumScaleFactor = 0.5
        minTempLabel.textColor = .white
    }
    
    private func styleMaxTempLabel() {
        maxTempLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        maxTempLabel.adjustsFontSizeToFitWidth = true
        maxTempLabel.minimumScaleFactor = 0.5
        maxTempLabel.textColor = .white
    }
    
    private func styleUpdatedInfoLabel() {
        updatedInfoLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        updatedInfoLabel.adjustsFontSizeToFitWidth = true
        updatedInfoLabel.minimumScaleFactor = 0.5
        updatedInfoLabel.textColor = .white
    }
    
}
