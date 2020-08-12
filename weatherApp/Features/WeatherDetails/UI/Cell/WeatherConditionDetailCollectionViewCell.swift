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
        String(describing: self)
    }
    
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
        layer.cornerRadius = 8
    }
    
    func set(conditionViewModel: ConditionInformationViewModel) {
        conditionLabel.text = conditionViewModel.title.uppercased()
        valueLabel.text = conditionViewModel.value
    }

}
