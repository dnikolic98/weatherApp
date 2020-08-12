//
//  WeatherConditionDetailCollectionViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class WeatherConditionDetailCollectionViewCell: UICollectionViewCell {
    
    static var typeName: String {
        return String(describing: self)
    }
    
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
    }
    
    func set(condition: ConditionInformation) {
        conditionLabel.text = condition.title.uppercased()
        valueLabel.text = condition.value
    }

}
