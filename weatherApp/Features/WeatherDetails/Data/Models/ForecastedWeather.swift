//
//  ForecastedWeather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 13/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct ForecastedWeather: Codable {
    
    let forecastedWeather: [DailyWeather]
    
    private enum CodingKeys : String, CodingKey {
        
        case forecastedWeather = "daily"
        
    }
}
