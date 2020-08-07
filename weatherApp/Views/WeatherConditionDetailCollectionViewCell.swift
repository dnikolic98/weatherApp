//
//  WeatherConditionDetailCollectionViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class WeatherConditionDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
    }
    
    func set(condition: String, value: String){
        conditionLabel.text = condition.uppercased()
        valueLabel.text = value
    }

}
