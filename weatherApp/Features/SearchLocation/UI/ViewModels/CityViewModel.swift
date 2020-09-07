//
//  CityViewModel.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

struct CityViewModel {
    
    let name: String
    let country: String
    let id: Int
    
    init(city: CityCoreData) {
        self.name = city.name
        self.country = city.country.uppercased()
        self.id = Int(city.id)
    }
    
}
