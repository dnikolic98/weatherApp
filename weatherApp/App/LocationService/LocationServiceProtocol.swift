//
//  LocationServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 02/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift

protocol LocationServiceProtocol {
    
    var location: Observable<Coordinates> { get }
    var isEnabled: Observable<Bool> { get }
    func checkLocationServicesAuthorization() -> Bool
    
}
