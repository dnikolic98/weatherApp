//
//  UserWarningView+Design.swift
//  weatherApp
//
//  Created by Dario Nikolic on 14/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import PureLayout

extension UserWarningView: DesignProtocol {
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        warningInfo = UILabel()
        addSubview(warningInfo)
    }
    
    func styleViews() {
        styleView()
        styleWarningLabel()
    }
    
    func defineLayoutForViews() {
        let offset: CGFloat = 15
        
        warningInfo.autoPinEdge(.leading, to: .leading, of: self, withOffset: offset)
        warningInfo.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -offset)
        warningInfo.autoPinEdge(.bottom, to: .bottom, of: self)
        warningInfo.autoPinEdge(.top, to: .top, of: self)
    }
    
    private func styleView() {
        backgroundColor = .white15
        layer.cornerRadius = 15
    }
    
    private func styleWarningLabel() {
        warningInfo.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        warningInfo.adjustsFontSizeToFitWidth = true
        warningInfo.minimumScaleFactor = 0.5
        warningInfo.textColor = .white
        warningInfo.textAlignment = .center
    }
    
}
