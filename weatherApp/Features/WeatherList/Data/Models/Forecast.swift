//
//  Forecast.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct Forecast: Codable {
    
    let feelsLikeTemperature: Double
    let humidity: Int
    let pressure: Int
    let temperature: Double
    let maxTemperature: Double
    let minTemperature: Double
    
    private enum CodingKeys : String, CodingKey {
        case feelsLikeTemperature = "feels_like"
        case humidity = "humidity"
        case pressure = "pressure"
        case temperature = "temp"
        case maxTemperature = "temp_max"
        case minTemperature = "temp_min"
    }
    
}
