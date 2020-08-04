//
//  Temperature.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class Temperature {
    let k: Double
    var c: Double!
    var f: Double!
    
    
    init(kelvin: Double){
        self.k = kelvin
        setupTemp()
    }
    
    func setupTemp(){
        self.c = convertToCelsius(kelvin: k)
        self.f = convertToFarenheit(kelvin: k)
    }
    
    func convertToCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    func convertToFarenheit(kelvin: Double) -> Double {
        return kelvin * 9/5 - 459.67
    }
}
