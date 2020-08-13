//
//  Wind.swift
//  weatherApp
//
//  Created by Dario Nikolic on 09/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct Wind: Codable {
    
    let speed: Double
    let directionDegree: Int
    
    private enum CodingKeys : String, CodingKey {
        case speed = "speed"
        case directionDegree = "deg"
    }
}
