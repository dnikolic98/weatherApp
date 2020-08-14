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
    
    private func setupSubviews() {
        contentView.addSubview(conditionLabel)
        contentView.addSubview(valueLabel)
    }
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: WeatherConditionDetailCollectionViewCell.height).isActive = true
        
        conditionLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: 15)
        conditionLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: 15)
        conditionLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: 15)
        
        valueLabel.autoPinEdge(.top, to: .top, of: conditionLabel, withOffset: 15)
        valueLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: 15)
        valueLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: 15)
        valueLabel.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: 15)
    }
    
}
