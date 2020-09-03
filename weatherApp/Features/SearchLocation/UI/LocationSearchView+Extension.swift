//
//  LocationSearchView+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

extension LocationSearchView {
    
    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        searchContainer = UIView()
        addSubview(searchContainer)
        
        searchBar = UISearchBar()
        searchContainer.addSubview(searchBar)
        
        resultsTableView = UITableView()
        addSubview(resultsTableView)
    }
    
    func styleViews() {
        styleView()
        styleSearchContainer()
        styleSearchBar()
        styleResultsTableView()
    }
    
    func defineLayoutForViews() {
        searchContainer.autoSetDimension(.height, toSize: 20)
        searchContainer.autoPinEdge(.leading, to: .leading, of: self)
        searchContainer.autoPinEdge(.trailing, to: .trailing, of: self)
        searchContainer.autoPinEdge(.top, to: .top, of: self)
        
        searchBar.autoPinEdge(.leading, to: .leading, of: searchContainer, withOffset: 5)
        searchBar.autoPinEdge(.trailing, to: .trailing, of: searchContainer, withOffset: -5)
        searchBar.autoPinEdge(.top, to: .top, of: searchContainer, withOffset: 5)
        searchBar.autoPinEdge(.bottom, to: .bottom, of: searchContainer, withOffset: -5)
        
        resultsTableView.autoPinEdge(.top, to: .top, of: searchContainer, withOffset: 5)
        searchContainer.autoPinEdge(.leading, to: .leading, of: self)
        searchContainer.autoPinEdge(.trailing, to: .trailing, of: self)
        searchContainer.autoPinEdge(.bottom, to: .bottom, of: self)
    }
    
    
    //MARK: - Styling Elements
    
    private func styleView() {
        backgroundColor = .white15
        layer.cornerRadius = 15
    }
    
    private func styleSearchContainer() {
//        searchContainer.font = UIFont.systemFont(ofSize: 35, weight: .bold)
    }
    
    private func styleSearchBar() {
//        searchBar.font = UIFont.systemFont(ofSize: 30, weight: .light)
    }
    
    private func styleResultsTableView() {
//        resultsTableView.font = UIFont.systemFont(ofSize: 150, weight: .thin)
    }
    
}
