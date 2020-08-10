//
//  Array+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 10/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

extension Array {
    
    func at(_ index: Int) -> Element? {
            if 0 <= index && index < count {
                return self[index]
            } else {
                return nil
            }
    }
    
}
