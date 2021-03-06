//
//  Weather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

struct Weather: Codable {
    
    let overview: String
    let icon: String
    var iconUrlString: String {
        "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
    private enum CodingKeys : String, CodingKey {
        case overview = "description"
        case icon = "icon"
    }
    
}
