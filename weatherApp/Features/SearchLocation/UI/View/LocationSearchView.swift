//
//  LocationSearchView.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class LocationSearchView: UIView {
    
    //MARK: - Properties
    
    var searchContainer: UIView!
    var searchBar: UISearchBar!
    var resultsTableView: UITableView!
    var backButton: UIButton!
    var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: - Initialization
    
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
    
    //MARK: - Public methods
    
    func startLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
}
