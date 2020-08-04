//
//  CurrentWeather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class CurrentWeather {
    let id: Int
    let forecast: Forecast
    let name: String
    let timezone: Int
    let weather: [Weather]
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],

            let id = jsonDict["id"] as? Int,
            let main = Forecast(json: jsonDict["main"] as Any),
            let name = jsonDict["name"] as? String,
            let timezone = jsonDict["timezone"] as? Int,
            let weather = jsonDict["weather"] as? [Any]{

            self.id = id
            self.forecast = main
            self.name = name
            self.timezone = timezone
            self.weather = weather.compactMap(Weather.init)
        } else {
            return nil
        }
    }
    
}
