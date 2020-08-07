//
//  UIView+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 06/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayerName = "gradientLayer"
        
        if let oldLayer = self.layer.sublayers?.filter({$0.name == gradientLayerName}).first {
            oldLayer.removeFromSuperlayer()
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0.0)
        gradientLayer.name = gradientLayerName
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
