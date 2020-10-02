//
//  WeatherConditionDetailCollectionViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class WeatherConditionDetailCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static var typeName: String {
        String(describing: self)
    }
    
    var conditionLabel: UILabel!
    var valueLabel: UILabel!
    
    //MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    //MARK: - Set data
    
    func set(conditionViewModel: ConditionInformationViewModel) {
        conditionLabel.text = conditionViewModel.title.uppercased()
        valueLabel.text = conditionViewModel.value
    }
    
}
