//
//  UIView+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 06/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

extension UIView {
    
    func setAnimatedGradientBackground(startColor: UIColor, endColor: UIColor) {
        let gradientLayerName = "gradientLayer"
        let newColors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        var oldColors: [CGColor]? = nil
        
        if let oldLayer = layer.sublayers?.filter({ $0.name == gradientLayerName }).first as? CAGradientLayer, let colors = oldLayer.colors as? [CGColor] {
            oldLayer.removeFromSuperlayer()
            oldColors = colors
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = newColors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0.0)
        gradientLayer.name = gradientLayerName
        
        if let oldColors = oldColors, oldColors != newColors {
            gradientLayer.colors = oldColors
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                gradientLayer.colors = newColors
            }
            gradientLayer.add(createGradientAnimation(toValue: newColors), forKey: "colorChange")
            CATransaction.commit()
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func createGradientAnimation(toValue: [CGColor]) -> CABasicAnimation {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        
        gradientChangeAnimation.duration = 2.0
        gradientChangeAnimation.toValue = toValue
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        
        return gradientChangeAnimation
    }
    
}
