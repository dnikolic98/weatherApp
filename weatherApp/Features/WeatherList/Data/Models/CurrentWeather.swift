//
//  CurrentWeather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//


struct CurrentWeather: Codable {
    
    let id: Int
    let coord: Coordinates
    let forecast: Forecast
    let name: String
    let weather: [Weather]
    let wind: Wind

    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case coord = "coord"
        case forecast = "main"
        case name = "name"
        case weather = "weather"
        case wind = "wind"
    }
}
