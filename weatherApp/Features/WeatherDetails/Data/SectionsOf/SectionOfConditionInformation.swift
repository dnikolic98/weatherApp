//
//  SectionsOfDailyWeather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 11/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxDataSources

struct SectionOfConditionInformation {
    
  var items: [Item]
    
}

extension SectionOfConditionInformation: SectionModelType {
    
  typealias Item = ConditionInformationViewModel

   init(original: SectionOfConditionInformation, items: [Item]) {
    self = original
    self.items = items
  }
    
}
