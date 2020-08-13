//
//  DailyWeather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 13/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

struct DailyWeather: Codable {
    
    let forecastTime: Int
    let sunrise: Int
    let sunset: Int
    let temperature: DailyTemperature
    let pressure: Double
    let humidity: Int
    let weather: [Weather]
    
    
    private enum CodingKeys : String, CodingKey {
        
        case forecastTime = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case temperature = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case weather = "weather"
        
    }
}
