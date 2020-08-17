//
//  DailyTemperature.swift
//  weatherApp
//
//  Created by Dario Nikolic on 13/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct DailyTemperature: Codable {
    
    let min: Double
    let max: Double
    let morning: Double
    let day: Double
    let evening: Double
    let night: Double
    
    private enum CodingKeys : String, CodingKey {
        case min = "min"
        case max = "max"
        case morning = "morn"
        case day = "day"
        case evening = "eve"
        case night = "night"
    }
    
}
