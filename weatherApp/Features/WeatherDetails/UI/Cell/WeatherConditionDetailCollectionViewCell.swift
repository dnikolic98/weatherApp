//
//  WeatherConditionDetailCollectionViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

class WeatherConditionDetailCollectionViewCell: UICollectionViewCell {
    
    private let conditionLabel = UILabel(forAutoLayout: ())
    private let valueLabel = UILabel(forAutoLayout: ())
    
    static let height: CGFloat = 100
    static var typeName: String {
        String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func set(conditionViewModel: ConditionInformationViewModel) {
        conditionLabel.text = conditionViewModel.title.uppercased()
        valueLabel.text = conditionViewModel.value
    }
    
    //MARK: - Styling UI Elements
    
    private func commonInit() {
        setupSubviews()
        styleConditionLabel()
        styleValueLabel()
        setupLayout()
        
        contentView.backgroundColor = .black20
        contentView.layer.cornerRadius = 8
    }
    
    private func styleConditionLabel() {
        conditionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        conditionLabel.textColor = .white70
    }
    
    private func styleValueLabel() {
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = .white
    }
    
    //MARK: - Setting Up Layout
    
    private func setupSubviews() {
        contentView.addSubview(conditionLabel)
        contentView.addSubview(valueLabel)
    }
    
    private func setupLayout() {
        let offset: CGFloat = 15
        
        heightAnchor.constraint(equalToConstant: WeatherConditionDetailCollectionViewCell.height).isActive = true
        
        conditionLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: offset)
        conditionLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
        conditionLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: offset)
        
        valueLabel.autoPinEdge(.top, to: .bottom, of: conditionLabel, withOffset: offset)
        valueLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
        valueLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: offset)
    }
    
}
