//
//  Forecast.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

//TODO: - popraviti varijable nazive
class Forecast {
    let feelsLike: Temperature
    let humidity: Int
    let pressure: Int
    let temp: Temperature
    let temp_max: Temperature
    let temp_min: Temperature
    
     init?(json: Any) {
           if let jsonDict = json as? [String: Any],

               let feelsLike = jsonDict["feels_like"] as? Double,
               let humidity = jsonDict["humidity"] as? Int,
               let pressure = jsonDict["pressure"] as? Int,
               let temp = jsonDict["temp"] as? Double,
               let temp_max = jsonDict["temp_max"] as? Double,
               let temp_min = jsonDict["temp_min"] as? Double {

               self.feelsLike = Temperature(kelvin: feelsLike)
               self.humidity = humidity
               self.pressure = pressure
               self.temp = Temperature(kelvin: temp)
               self.temp_max = Temperature(kelvin: temp_max)
               self.temp_min = Temperature(kelvin: temp_min)
            
           } else {
               return nil
           }
       }
}
