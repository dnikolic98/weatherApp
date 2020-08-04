//
//  DetailWeatherViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher

class DetailWeatherViewController: UIViewController {
    var currentWeather: CurrentWeather!
    
    @IBOutlet private weak var temp: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet private weak var weatherDescription: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var minTemp: UILabel!
    @IBOutlet private weak var maxTemp: UILabel!
    @IBOutlet private weak var feelsLike: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUiElements()
    }
    
    private func setupUiElements(){
        let forecast = currentWeather.forecast
        
        self.title = currentWeather.name
        
        temp.text = tempFormat(temp: forecast.temp.c)
        minTemp.text = tempFormat(temp: forecast.temp_min.c)
        maxTemp.text = tempFormat(temp: forecast.temp_max.c)
        feelsLike.text = tempFormat(temp: forecast.feelsLike.c)
        weatherDescription.text = currentWeather.weather.description
        humidity.text = "\(forecast.humidtiy) %"
        pressure.text = "\(forecast.pressure) hPa"
        
        let urlString = currentWeather.weather.iconUrlString
        if
            let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func tempFormat(temp: Double) -> String{
        let temp = Int(temp)
        return "\(temp) °C"
    }
    
}
