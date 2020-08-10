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
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var weatherDescription: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var pressure: UILabel!
    @IBOutlet private weak var minTemp: UILabel!
    @IBOutlet private weak var maxTemp: UILabel!
    @IBOutlet private weak var feelsLike: UILabel!
    
    convenience init(currentWeather: CurrentWeather) {
        self.init()
        
        self.currentWeather = currentWeather
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentWeather != nil {
            setWeatherInformation()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
    }
    
    //MARK: - UI elements setup
    
    private func setWeatherInformation() {
        let forecast = currentWeather.forecast
        
        title = currentWeather.name
        temp.text = Temperature.celsiusToString(temp: forecast.temperature.celsius)
        minTemp.text = Temperature.celsiusToString(temp: forecast.minTemperature.celsius)
        maxTemp.text = Temperature.celsiusToString(temp: forecast.maxTemperature.celsius)
        feelsLike.text = Temperature.celsiusToString(temp: forecast.feelsLikeTemperature.celsius)
        weatherDescription.text = currentWeather.weather.description.firstCapitalized
        humidity.text = "\(forecast.humidity) %"
        pressure.text = "\(forecast.pressure) hPa"
        
        let urlString = currentWeather.weather.iconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }

}
