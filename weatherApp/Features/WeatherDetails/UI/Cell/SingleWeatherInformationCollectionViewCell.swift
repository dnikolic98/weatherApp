//
//  SingleWeatherInformationCollectionViewCellCollectionViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 12/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher
import PureLayout

class SingleWeatherInformationCollectionViewCell: UICollectionViewCell {
    
    private let headerLabel = UILabel(forAutoLayout: ())
    private let mainInformationLabel = UILabel(forAutoLayout: ())
    private let translucentView = UIView(forAutoLayout: ())
    private let weatherIcon = UIImageView(forAutoLayout: ())
    
    static let height: CGFloat = 140
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = ""
        mainInformationLabel.text = ""
        weatherIcon.image = nil
    }
    
    func set(weatherInfo: SingleWeatherInformationViewModel) {
        headerLabel.text = weatherInfo.header
        mainInformationLabel.text = weatherInfo.body
        
        let urlString = weatherInfo.iconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    //MARK: - Styling UI Elements
    
    private func commonInit() {
        setupSubviews()
        styleHeaderLabel()
        styleMainInformationLabel()
        styleTranslucentView()
        setupLayout()
    }
    
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
        translucentView.layer.cornerRadius = 8
    }
    
    //MARK: - Setting Up Layout
    
    private func setupSubviews() {
        addSubview(headerLabel)
        addSubview(translucentView)
        addSubview(mainInformationLabel)
        addSubview(weatherIcon)
    }
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: SingleWeatherInformationCollectionViewCell.height).isActive = true
        
        headerLabel.autoPinEdge(.top, to: .top, of: contentView)
        headerLabel.autoPinEdge(.trailing, to: .trailing, of: contentView)
        headerLabel.autoPinEdge(.leading, to: .leading, of: contentView)
        
        translucentView.autoPinEdge(.top, to: .bottom, of: headerLabel, withOffset: 5)
        translucentView.autoPinEdge(.trailing, to: .trailing, of: contentView)
        translucentView.autoPinEdge(.leading, to: .leading, of: contentView)
        translucentView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: -5)
        
        weatherIcon.autoSetDimension(.height, toSize: 50, relation: .lessThanOrEqual)
        weatherIcon.autoSetDimension(.width, toSize: 50, relation: .lessThanOrEqual)
        weatherIcon.autoPinEdge(.top, to: .top, of: translucentView, withOffset: 5)
        weatherIcon.autoAlignAxis(.vertical, toSameAxisOf: translucentView)
        
        mainInformationLabel.autoPinEdge(.top, to: .bottom, of: weatherIcon)
        mainInformationLabel.autoPinEdge(.bottom, to: .bottom, of: translucentView, withOffset: -5)
        mainInformationLabel.autoPinEdge(.leading, to: .leading, of: translucentView)
        mainInformationLabel.autoPinEdge(.trailing, to: .trailing, of: translucentView)
    }
    
}
