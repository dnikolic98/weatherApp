//
//  LocationSearchView.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class LocationSearchView: UIView {
    
    var searchContainer: UIView!
    var searchBar: UISearchBar!
    var resultsTableView: UITableView!
    var backButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        setDefaultGradient()
    }
    
}
