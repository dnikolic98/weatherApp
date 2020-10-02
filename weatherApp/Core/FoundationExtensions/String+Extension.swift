//
//  CapitalizeFirstStringExtension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

extension String {
    
    var firstCapitalized: String {
        guard !isEmpty else { return self }
        
        return prefix(1).capitalized + dropFirst()
    }
    
}
