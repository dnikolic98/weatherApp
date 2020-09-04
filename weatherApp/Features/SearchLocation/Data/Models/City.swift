//
//  City.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

struct City: Codable {
    
    let id: Int
    let name: String
    let state: String
    let country: String
    let coordinates: Coordinates
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case state = "state"
        case country = "country"
        case coordinates = "coord"
    }
    
}
