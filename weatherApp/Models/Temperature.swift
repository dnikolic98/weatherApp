//
//  Temperature.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct Temperature {
    let kelvin: Double
    var celsius: Double {
        kelvin - 273.15
    }
    var fahrenheit: Double {
        kelvin * 9/5 - 459.67
    }
    
    static func celsiusToString(temp: Double) -> String{
        let temp = Int(temp)
        return "\(temp) °C"
    }
}
