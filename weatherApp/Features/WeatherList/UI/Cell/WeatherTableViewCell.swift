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
    
    //MARK: - Properties
    
    static var typeName: String {
        String(describing: self)
    }
    
    var locationNameLabel: UILabel!
    var weatherDescriptionLabel: UILabel!
    var currentTempLabel: UILabel!
    var minMaxTempLabel: UILabel!
    var weatherIcon: UIImageView!
    var customContentView: UIView!
    
    //MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
    }
    
    override func layoutSubviews() {
        setLayerMask()
    }
    
    //MARK: - Set data
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherDescriptionLabel.text = ""
        minMaxTempLabel.text = ""
        currentTempLabel.text = ""
        locationNameLabel.text = ""
        weatherIcon.image = nil
        customContentView.hero.id = ""
    }
    
    func set(withWeather currentWeather: CurrentWeatherViewModel) {
        locationNameLabel.text = currentWeather.name
        weatherDescriptionLabel.text = currentWeather.weatherDescription.firstCapitalized
        currentTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.temperature)
        minMaxTempLabel.text = minMaxTemperatureFormat(min: currentWeather.minTemperature, max: currentWeather.maxTemperature)
        setupHero(currentWeather: currentWeather)
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    //MARK: - Helpers
    
    private func minMaxTemperatureFormat(min: Int, max: Int) -> String {
        let min = String(format: LocalizedStrings.temperatureValueFormat, min)
        let max = String(format: LocalizedStrings.temperatureValueFormat, max)
        return "\(max) / \(min)"
    }
    
    private func setupHero(currentWeather: CurrentWeatherViewModel) {
        customContentView.hero.id = "\(currentWeather.id)"
        locationNameLabel.hero.modifiers = [.fade]
        weatherIcon.hero.modifiers = [.fade]
        currentTempLabel.hero.modifiers = [.fade]
        minMaxTempLabel.hero.modifiers = [.fade]
        weatherDescriptionLabel.hero.modifiers = [.fade]
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
    
}

