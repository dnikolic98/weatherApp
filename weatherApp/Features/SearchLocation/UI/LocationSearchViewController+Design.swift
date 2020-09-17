
//
//  LocationSearchViewController+Design.swift
//  weatherApp
//
//  Created by Dario Nikolic on 16/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import PureLayout

extension LocationSearchViewController: DesignProtocol {
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        locationSearchView = LocationSearchView()
        view.addSubview(locationSearchView)
    }
    
    func styleViews() {
    }
    
    func defineLayoutForViews() {
        locationSearchView.autoPinEdgesToSuperviewEdges()
    }
    
}
