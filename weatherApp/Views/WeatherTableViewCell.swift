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
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var minMaxTemp: UILabel!
    
    func setup(withWeather currentWeather: CurrentWeather) {
        let forecast = currentWeather.forecast
        
        locationName.text = currentWeather.name
        weatherDescription.text = currentWeather.weather.description
        currentTemp.text = tempFormat(temp: forecast.temp.c)
        minMaxTemp.text = minMaxFormat(min: forecast.temp_min.c, max: forecast.temp_max.c)
        
        let urlString = currentWeather.weather.iconUrlString
        if
            let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherDescription.text = ""
        minMaxTemp.text = ""
        currentTemp.text = ""
        locationName.text = ""
        weatherIcon?.image = nil
    }
    
    private func tempFormat(temp: Double) -> String{
        let temp = Int(temp)
        return "\(temp) °C"
    }
    
    private func minMaxFormat(min: Double, max: Double) -> String{
        let min = tempFormat(temp: min)
        let max = tempFormat(temp: max)
        return "\(min) - \(max)"
    }
}

