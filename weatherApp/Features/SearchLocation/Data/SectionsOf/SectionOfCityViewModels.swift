//
//  SectionOfCityViewModels.swift
//  weatherApp
//
//  Created by Dario Nikolic on 10/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxDataSources

struct SectionOfCityViewModels {
    
  var items: [Item]
    
}

extension SectionOfCityViewModels: SectionModelType {
    
    typealias Item = CityViewModel
    
    init(original: SectionOfCityViewModels, items: [Item]) {
        self = original
        self.items = items
    }
    
}
