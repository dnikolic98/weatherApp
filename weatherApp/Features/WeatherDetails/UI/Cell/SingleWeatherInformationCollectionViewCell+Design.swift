//
//  SingleWeatherInformationCollectionViewCell+Design.swift
//  weatherApp
//
//  Created by Dario Nikolic on 15/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

extension SingleWeatherInformationCollectionViewCell: DesignProtocol {
    
    static let height: CGFloat = 140
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        translucentView = UIView()
        addSubview(translucentView)
        
        headerLabel = UILabel()
        addSubview(headerLabel)
        
        mainInformationLabel = UILabel()
        addSubview(mainInformationLabel)
        
        weatherIcon = UIImageView()
        addSubview(weatherIcon)
    }
    
    func styleViews() {
        styleHeaderLabel()
        styleMainInformationLabel()
        styleTranslucentView()
    }
    
    func defineLayoutForViews() {
        let offset: CGFloat = 5
        
        heightAnchor.constraint(equalToConstant: SingleWeatherInformationCollectionViewCell.height).isActive = true
        
        headerLabel.autoPinEdge(.top, to: .top, of: contentView)
        headerLabel.autoPinEdge(.trailing, to: .trailing, of: contentView)
        headerLabel.autoPinEdge(.leading, to: .leading, of: contentView)
        
        translucentView.autoPinEdge(.top, to: .bottom, of: headerLabel, withOffset: offset)
        translucentView.autoPinEdge(.trailing, to: .trailing, of: contentView)
        translucentView.autoPinEdge(.leading, to: .leading, of: contentView)
        translucentView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -offset)
        
        weatherIcon.autoSetDimension(.height, toSize: 50, relation: .lessThanOrEqual)
        weatherIcon.autoSetDimension(.width, toSize: 50, relation: .lessThanOrEqual)
        weatherIcon.autoPinEdge(.top, to: .top, of: translucentView, withOffset: offset)
        weatherIcon.autoAlignAxis(.vertical, toSameAxisOf: translucentView)
        
        mainInformationLabel.autoPinEdge(.top, to: .bottom, of: weatherIcon)
        mainInformationLabel.autoPinEdge(.bottom, to: .bottom, of: translucentView, withOffset: -offset)
        mainInformationLabel.autoPinEdge(.leading, to: .leading, of: translucentView)
        mainInformationLabel.autoPinEdge(.trailing, to: .trailing, of: translucentView)
    }
    
    //MARK: - Styling UI Elements
    
    private func styleHeaderLabel() {
        headerLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
    }
    
    private func styleMainInformationLabel() {
        mainInformationLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        mainInformationLabel.adjustsFontSizeToFitWidth = true
        mainInformationLabel.minimumScaleFactor = 0.5
        mainInformationLabel.textColor = .white
        mainInformationLabel.numberOfLines = 0
        mainInformationLabel.textAlignment = .center
    }
    
    private func styleTranslucentView() {
        translucentView.backgroundColor = .black20
        translucentView.layer.cornerRadius = 15
    }
    
}
