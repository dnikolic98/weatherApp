//
//  ForecastedWeather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 13/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct ForecastedWeather: Codable {
    
    let forecastedWeather: [DailyWeather]
    let hourlyForecast: [HourlyWeather]
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys : String, CodingKey {
        case forecastedWeather = "daily"
        case hourlyForecast = "hourly"
        case latitude = "lat"
        case longitude = "lon"
    }
    
}
