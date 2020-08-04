//
//  Forecast.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class Forecast {
    let feelsLike: Double
    let humidtiy: Int
    let pressure: Int
    let temp: Double
    let temp_max: Double
    let temp_min: Double
    
     init?(json: Any) {
           if let jsonDict = json as? [String: Any],

               let feelsLike = jsonDict["feels_like"] as? Double,
               let humidtiy = jsonDict["humidity"] as? Int,
               let pressure = jsonDict["pressure"] as? Int,
               let temp = jsonDict["temp"] as? Double,
               let temp_max = jsonDict["temp_max"] as? Double,
               let temp_min = jsonDict["temp_min"] as? Double {

               self.feelsLike = feelsLike
               self.humidtiy = humidtiy
               self.pressure = pressure
               self.temp = temp
               self.temp_max = temp_max
               self.temp_min = temp_min
            
           } else {
               return nil
           }
       }
    
    func convertToCelsius(degrees: Double) -> Double {
        return degrees - 273.15
    }
}
