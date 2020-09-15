//
//  WeatherTableViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class WeatherTableViewCell: UITableViewCell {
    
    private let locationNameLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let minMaxTempLabel = UILabel()
    private let weatherIcon = UIImageView()
    
    static let height: CGFloat = 100
    static var typeName: String {
        String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        setLayerMask()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherDescriptionLabel.text = ""
        minMaxTempLabel.text = ""
        currentTempLabel.text = ""
        locationNameLabel.text = ""
        weatherIcon.image = nil
        contentView.hero.id = ""
    }
    
    func set(withWeather currentWeather: CurrentWeatherViewModel) {
        locationNameLabel.text = currentWeather.name
        weatherDescriptionLabel.text = currentWeather.weatherDescription.firstCapitalized
        currentTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.temperature)
        minMaxTempLabel.text = minMaxTemperatureFormat(min: currentWeather.minTemperature, max: currentWeather.maxTemperature)
        contentView.hero.id = "\(currentWeather.id)"
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func minMaxTemperatureFormat(min: Int, max: Int) -> String {
        let min = String(format: LocalizedStrings.temperatureValueFormat, min)
        let max = String(format: LocalizedStrings.temperatureValueFormat, max)
        return "\(max) / \(min)"
    }
    
    private func setupHero() {
        locationNameLabel.hero.modifiers = [.fade]
        weatherIcon.hero.modifiers = [.fade]
        currentTempLabel.hero.modifiers = [.fade]
        minMaxTempLabel.hero.modifiers = [.fade]
        weatherDescriptionLabel.hero.modifiers = [.fade]
    }
    
    //MARK: - Styling UI Elements
    
    private func commonInit() {
        setupSubviews()
        styleLocationNameLabel()
        styleWeatherDescriptionLabel()
        styleCurrentTempLabel()
        styleMinMaxTempLabel()
        setupLayout()
        setupHero()
        
        backgroundColor = .white15
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
    
    private func setLayerMask() {
        let verticalPadding: CGFloat = 10
        let horizontalPadding: CGFloat = 20
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 15
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: horizontalPadding / 2, dy: verticalPadding / 2)
        layer.mask = maskLayer
    }
    
    //MARK: - Setting Up Layout
    
    private func setupSubviews() {
        contentView.addSubview(locationNameLabel)
        contentView.addSubview(weatherDescriptionLabel)
        contentView.addSubview(currentTempLabel)
        contentView.addSubview(minMaxTempLabel)
        contentView.addSubview(weatherIcon)
    }

    private func setupLayout() {
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxTempLabel.translatesAutoresizingMaskIntoConstraints = false


        heightAnchor.constraint(equalToConstant: WeatherTableViewCell.height).isActive = true
        
        weatherIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        weatherIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
        
        locationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        locationNameLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 10).isActive = true
        
        weatherDescriptionLabel.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 10).isActive = true
        weatherDescriptionLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 10).isActive = true
        weatherDescriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: -25).isActive = true

        currentTempLabel.leadingAnchor.constraint(greaterThanOrEqualTo: locationNameLabel.trailingAnchor, constant: 20).isActive = true
        currentTempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        currentTempLabel.centerXAnchor.constraint(equalTo: minMaxTempLabel.centerXAnchor).isActive = true
        
        minMaxTempLabel.leadingAnchor.constraint(greaterThanOrEqualTo: weatherDescriptionLabel.trailingAnchor, constant: 20).isActive = true
        minMaxTempLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 10).isActive = true
        minMaxTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        minMaxTempLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: -25).isActive = true
    }
    
}

