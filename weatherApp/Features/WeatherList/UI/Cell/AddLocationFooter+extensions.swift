//
//  AddLocationView+extensions.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

extension AddLocationFooter {
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        addButton = UIButton()
        addSubview(addButton)
    }
    
    func styleViews() {
        styleAddButton()
    }
    
    func defineLayoutForViews() {
        let leftRightOffset: CGFloat = 15
        
        addButton.autoPinEdge(.leading, to: .leading, of: self, withOffset: leftRightOffset)
        addButton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -leftRightOffset)
        addButton.autoPinEdge(.top, to: .top, of: self)
        addButton.autoPinEdge(.bottom, to: .bottom, of: self)
    }
    
    
    //MARK: - Styling Elements
    
    private func styleAddButton() {
        addButton.setTitle(LocalizedStrings.addLocation, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addButton.backgroundColor = .white15
        addButton.layer.cornerRadius = 12
        addButton.contentHorizontalAlignment = .left;
        addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        addButton.isUserInteractionEnabled = true
    }
    
}
