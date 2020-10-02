//
//  LocationNameTableViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 09/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import PureLayout

extension LocationNameTableViewCell: DesignProtocol {
    
    static let height: CGFloat = 50
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        nameLabel = UILabel()
        addSubview(nameLabel)
    }
    
    func styleViews() {
        styleView()
        styleNameLabel()
    }
    
    func defineLayoutForViews() {
        let offset: CGFloat = 15
        
        nameLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: offset)
        nameLabel.autoPinEdge(.trailing, to: .trailing, of: contentView, withOffset: offset)
        nameLabel.autoPinEdge(.leading, to: .leading, of: contentView, withOffset: 2 * offset)
    }
    
    //MARK: - Styling UI Elements
    
    private func styleView() {
        backgroundColor = .clear
        contentView.backgroundColor = CellBackgrounds.standard
        contentView.layer.cornerRadius = 15
    }
    
    private func styleNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .white70
    }
    
}

