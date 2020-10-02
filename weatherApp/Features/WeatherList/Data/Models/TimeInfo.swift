//
//  TimeInfo.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct TimeInfo: Codable {
    
    let sunrise: Int
    let sunset: Int
    
    private enum CodingKeys : String, CodingKey {
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
    
}
