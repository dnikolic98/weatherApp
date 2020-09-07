//
//  LocationNameCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

class LocationNameTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel(forAutoLayout: ())
    private let countryLabel = UILabel(forAutoLayout: ())
    
    static let height: CGFloat = 50
    static var typeName: String {
        String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        countryLabel.text = ""
    }
    
    func set(with city: CityViewModel) {
        nameLabel.text = city.name
        countryLabel.text = city.country
    }
    
    //MARK: - Styling UI Elements
    
    private func commonInit() {
        setupSubviews()
        styleConditionLabel()
        styleValueLabel()
        setupLayout()
        
        contentView.backgroundColor = .black20
        contentView.layer.cornerRadius = 15
    }
    
    private func styleConditionLabel() {
//        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        nameLabel.textColor = .white70
    }
    
    private func styleValueLabel() {
//        countryLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        countryLabel.textColor = .white
    }
    
    //MARK: - Setting Up Layout
    
    private func setupSubviews() {
        contentView.addSubview(nameLabel)
//        contentView.addSubview(countryLabel)
    }
    
    private func setupLayout() {
        let offset: CGFloat = 15
        
//        heightAnchor.constraint(equalToConstant: LocationNameTableViewCell.height).isActive = true
        
        nameLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: offset)
        nameLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
        nameLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: offset)
        
//        countryLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: offset)
//        countryLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
//        countryLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: offset)
    }
    
}
