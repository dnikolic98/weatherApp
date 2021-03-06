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
    let id: Int
    let selected: Bool
    
    init(city: CityCoreData, isSelected: Bool) {
        self.name = String(format: "%@ (%@)", city.name, city.country.uppercased())
        self.id = Int(city.id)
        self.selected = isSelected
    }
    
}
