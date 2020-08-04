//
//  Weather.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

class Weather {
    let description: String
    let icon: String
    let id: Int
    let main: String
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],

            let description = jsonDict["description"] as? String,
            let icon = jsonDict["icon"] as? String,
            let id = jsonDict["id"] as? Int,
            let main = jsonDict["main"] as? String {

            self.description = description
            self.icon = icon
            self.id = id
            self.main = main
        } else {
            return nil
        }
    }
}
