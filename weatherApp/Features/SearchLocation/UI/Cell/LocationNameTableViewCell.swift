//
//  LocationNameCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class LocationNameTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var nameLabel: UILabel!
    
    static var typeName: String {
        String(describing: self)
    }
    
    //MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
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
    
    //MARK: - Public methods
    
    func set(with city: CityViewModel) {
        nameLabel.text = city.name
        if city.selected {
            contentView.backgroundColor = CellBackgrounds.selected
            isUserInteractionEnabled = false
        }
    }
    
    //MARK: - Helpers
    
    private func setLayerMask() {
        let verticalPadding: CGFloat = 10
        let horizontalPadding: CGFloat = 20
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 15
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: horizontalPadding / 2, dy: verticalPadding / 2)
        layer.mask = maskLayer
    }
    
}
