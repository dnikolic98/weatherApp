//
//  HourlyForecast.swift
//  weatherApp
//
//  Created by Dario Nikolic on 24/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct HourlyWeather: Codable {
    
    let forecastTime: Int
    let temperature: Double
    let pressure: Double
    let humidity: Int
    let weather: [Weather]
    
    private enum CodingKeys : String, CodingKey {
        case forecastTime = "dt"
        case temperature = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case weather = "weather"
    }
    
}
