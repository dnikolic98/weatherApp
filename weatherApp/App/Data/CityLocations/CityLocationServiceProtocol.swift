//
//  CityLocationServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift

protocol CityLocationServiceProtocol {
    
    var cityList: Observable<[City]> { get }
    
}
