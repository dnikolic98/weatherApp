//
//  SectionsOfDailyWeather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxDataSources

struct SectionOfSingleWeatherInformation {
    
    var items: [Item]
    
}

extension SectionOfSingleWeatherInformation: SectionModelType {
    
    typealias Item = SingleWeatherInformationViewModel
    
    init(original: SectionOfSingleWeatherInformation, items: [Item]) {
        self = original
        self.items = items
    }
    
}
