//
//  Coordinates.swift
//  weatherApp
//
//  Created by Dario Nikolic on 13/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct Coordinates: Codable {
    
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys : String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
}
