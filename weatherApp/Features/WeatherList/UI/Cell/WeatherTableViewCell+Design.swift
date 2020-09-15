//
//  WeatherTableViewCell+Design.swift
//  weatherApp
//
//  Created by Dario Nikolic on 15/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

extension WeatherTableViewCell: DesignProtocol {
    
    static let height: CGFloat = 100
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        customContentView = UIView()
        contentView.addSubview(customContentView)
        
        locationNameLabel = UILabel()
        customContentView.addSubview(locationNameLabel)
        
        weatherDescriptionLabel = UILabel()
        customContentView.addSubview(weatherDescriptionLabel)
        
        currentTempLabel = UILabel()
        customContentView.addSubview(currentTempLabel)
        
        minMaxTempLabel = UILabel()
        customContentView.addSubview(minMaxTempLabel)
        
        weatherIcon = UIImageView()
        customContentView.addSubview(weatherIcon)
    }
    
    func styleViews() {
        styleView()
        styleContentView()
        styleLocationNameLabel()
        styleWeatherDescriptionLabel()
        styleCurrentTempLabel()
        styleMinMaxTempLabel()
    }
    
    func defineLayoutForViews() {
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: WeatherTableViewCell.height).isActive = true
        
        customContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        customContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        customContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        weatherIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 20).isActive = true
        weatherIcon.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor, constant: -20).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 15).isActive = true
        
        locationNameLabel.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 25).isActive = true
        locationNameLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 10).isActive = true
        
        weatherDescriptionLabel.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 10).isActive = true
        weatherDescriptionLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 10).isActive = true
        weatherDescriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: -25).isActive = true
        
        currentTempLabel.leadingAnchor.constraint(greaterThanOrEqualTo: locationNameLabel.trailingAnchor, constant: 20).isActive = true
        currentTempLabel.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 25).isActive = true
        currentTempLabel.centerXAnchor.constraint(equalTo: minMaxTempLabel.centerXAnchor).isActive = true
        
        minMaxTempLabel.leadingAnchor.constraint(greaterThanOrEqualTo: weatherDescriptionLabel.trailingAnchor, constant: 20).isActive = true
        minMaxTempLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 10).isActive = true
        minMaxTempLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -25).isActive = true
        minMaxTempLabel.bottomAnchor.constraint(greaterThanOrEqualTo: customContentView.topAnchor, constant: -25).isActive = true
    }
    
    //MARK: - Styling UI Elements
    
    private func styleView() {
        backgroundColor = .white15
    }
    
    private func styleContentView() {
        contentView.backgroundColor = .clear
        customContentView.layer.cornerRadius = 15
    }
    
    private func styleLocationNameLabel() {
        locationNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        locationNameLabel.adjustsFontSizeToFitWidth = true
        locationNameLabel.minimumScaleFactor = 0.5
        locationNameLabel.textColor = .white
    }
    
    private func styleWeatherDescriptionLabel() {
        weatherDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        weatherDescriptionLabel.adjustsFontSizeToFitWidth = true
        weatherDescriptionLabel.minimumScaleFactor = 0.5
        weatherDescriptionLabel.textColor = .white
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func styleCurrentTempLabel() {
        currentTempLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        currentTempLabel.adjustsFontSizeToFitWidth = true
        currentTempLabel.minimumScaleFactor = 0.5
        currentTempLabel.textColor = .white
    }
    
    private func styleMinMaxTempLabel() {
        minMaxTempLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        minMaxTempLabel.adjustsFontSizeToFitWidth = true
        minMaxTempLabel.minimumScaleFactor = 0.5
        minMaxTempLabel.textColor = .white
    }
    
}
