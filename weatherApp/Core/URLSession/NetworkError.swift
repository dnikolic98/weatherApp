//
//  NetworkError.swift
//  weatherApp
//
//  Created by Dario Nikolic on 01/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

enum NetworkError: Error {
    
    case transportError(Error)
    
    case serverSideError(Int)
    
    case noResponse
    
    case noData
    
    case badURL
    
}
