//
//  LocationServiceProtocol.swift
//  weatherApp
//
//  Created by Dario Nikolic on 02/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

protocol LocationServiceProtocol {
    
    typealias LocationServiceCompletion = (Coordinates?, Error?) -> (Void)
    
    func getLocation(completion: @escaping LocationServiceCompletion)
    
}
