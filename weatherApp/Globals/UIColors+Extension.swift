//
//  UIColors+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 10/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

extension UIColor {

    static let grayBlueTint = UIColor(hex: 0x859398)
    static let darkNavyBlue = UIColor(hex: 0x283048)
    static let darkPurple = UIColor(hex: 0x514A9D)
    static let teal = UIColor(hex: 0x24C6DC)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
