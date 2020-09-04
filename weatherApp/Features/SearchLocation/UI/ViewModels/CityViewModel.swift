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
    
    init(city: City) {
        self.name = city.name
        self.id = city.id
    }
    
}
