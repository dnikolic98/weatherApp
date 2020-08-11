//
//  WeatherTableViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherTableViewCell: UITableViewCell {
    
    static var typeName: String {
        return String(describing: self)
    }
    
    @IBOutlet private weak var paddedView: UIView!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var locationName: UILabel!
    @IBOutlet private weak var weatherDescription: UILabel!
    @IBOutlet private weak var currentTemp: UILabel!
    @IBOutlet private weak var minMaxTemp: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherDescription.text = ""
        minMaxTemp.text = ""
        currentTemp.text = ""
        locationName.text = ""
        weatherIcon?.image = nil
    }
    
    override func layoutSubviews() {
        setLayerMask()
    }
    
    //MARK: - UI elements setup
    
    func set(withWeather currentWeather: CurrentWeatherViewModel) {
        
        locationName.text = currentWeather.name
        weatherDescription.text = currentWeather.weatherDescription.firstCapitalized
        currentTemp.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.temperature)
        minMaxTemp.text = minMaxFormat(min: currentWeather.minTemperature, max: currentWeather.maxTemperature)
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func minMaxFormat(min: Int, max: Int) -> String {
        let min = String(format: LocalizedStrings.temperatureValueFormat, min)
        let max = String(format: LocalizedStrings.temperatureValueFormat, max)
        return "\(max) / \(min)"
    }
    
    private func setLayerMask() {
        let verticalPadding: CGFloat = 10
        let horizontalPadding: CGFloat = 20
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: horizontalPadding / 2, dy: verticalPadding / 2)
        layer.mask = maskLayer
    }
}

