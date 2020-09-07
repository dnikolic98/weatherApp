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
        contentView.backgroundColor = CellBackgrounds.standard
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        setLayerMask()
    }
    
    func set(with city: CityViewModel) {
        nameLabel.text = city.name
        if city.selected {
            contentView.backgroundColor = CellBackgrounds.selected
            isUserInteractionEnabled = false
        }
    }
    
    //MARK: - Styling UI Elements
    
    private func commonInit() {
        setupSubviews()
        styleConditionLabel()
        setupLayout()
        
        backgroundColor = .clear
        contentView.backgroundColor = CellBackgrounds.standard
        contentView.layer.cornerRadius = 15
    }
    
    private func styleConditionLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .white70
    }
    
    private func setLayerMask() {
        let verticalPadding: CGFloat = 10
        let horizontalPadding: CGFloat = 20
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 15
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: horizontalPadding / 2, dy: verticalPadding / 2)
        layer.mask = maskLayer
    }
    
    //MARK: - Setting Up Layout
    
    private func setupSubviews() {
        contentView.addSubview(nameLabel)
    }
    
    private func setupLayout() {
        let offset: CGFloat = 15
        
        nameLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: offset)
        nameLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
        nameLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: 2 * offset)
    }
    
}
