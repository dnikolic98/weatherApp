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
    
    //MARK: - UI elements setup
    
    func set(withWeather currentWeather: CurrentWeather) {
        let forecast = currentWeather.forecast
        
        locationName.text = currentWeather.name
        weatherDescription.text = currentWeather.weather.description.firstCapitalized
        currentTemp.text = Temperature.celsiusToString(temp: forecast.temperature.celsius)
        minMaxTemp.text = minMaxFormat(min: forecast.minTemperature.celsius, max: forecast.maxTemperature.celsius)
        
        let urlString = currentWeather.weather.iconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func minMaxFormat(min: Double, max: Double) -> String{
        let min = Temperature.celsiusToString(temp: min)
        let max = Temperature.celsiusToString(temp: max)
        return "\(max) / \(min)"
    }
}

