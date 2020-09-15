//
//  WeatherConditionDetailCollectionViewCell+Design.swift
//  weatherApp
//
//  Created by Dario Nikolic on 15/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

extension WeatherConditionDetailCollectionViewCell: DesignProtocol {
    
    static let height: CGFloat = 100
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        conditionLabel = UILabel()
        contentView.addSubview(conditionLabel)
        
        valueLabel = UILabel()
        contentView.addSubview(valueLabel)
    }
    
    func styleViews() {
        styleContentView()
        styleConditionLabel()
        styleValueLabel()
    }
    
    func defineLayoutForViews() {
        let offset: CGFloat = 15
        
        heightAnchor.constraint(equalToConstant: WeatherConditionDetailCollectionViewCell.height).isActive = true
        
        conditionLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: offset)
        conditionLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
        conditionLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: offset)
        
        valueLabel.autoPinEdge(.top, to: .bottom, of: conditionLabel, withOffset: offset)
        valueLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
        valueLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: offset)
    }
    
    //MARK: - Styling UI Elements
    
    private func styleContentView() {
        contentView.backgroundColor = .black20
        contentView.layer.cornerRadius = 15
    }
    
    private func styleConditionLabel() {
        conditionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        conditionLabel.textColor = .white70
    }
    
    private func styleValueLabel() {
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = .white
    }
    
}
