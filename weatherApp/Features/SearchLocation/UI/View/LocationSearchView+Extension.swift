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
        
        backButton = UIButton()
        searchContainer.addSubview(backButton)
        
        searchBar = UISearchBar()
        searchContainer.addSubview(searchBar)
        
        resultsTableView = UITableView()
        addSubview(resultsTableView)
    }
    
    func styleViews() {
        styleBackButton()
        styleSearchBar()
        styleResultsTableView()
    }
    
    func defineLayoutForViews() {
        searchContainer.autoSetDimension(.height, toSize: 50)
        searchContainer.autoPinEdge(toSuperviewSafeArea: .leading)
        searchContainer.autoPinEdge(toSuperviewSafeArea: .trailing)
        searchContainer.autoPinEdge(toSuperviewSafeArea: .top)
        
        backButton.autoPinEdge(.leading, to: .leading, of: searchContainer, withOffset: 5)
        backButton.autoPinEdge(.top, to: .top, of: searchContainer, withOffset: 5)
        backButton.autoPinEdge(.bottom, to: .bottom, of: searchContainer, withOffset: -5)
        
        searchBar.autoPinEdge(.trailing, to: .trailing, of: searchContainer, withOffset: -5)
        searchBar.autoPinEdge(.leading, to: .trailing, of: backButton)
        searchBar.autoPinEdge(.top, to: .top, of: searchContainer, withOffset: 5)
        searchBar.autoPinEdge(.bottom, to: .bottom, of: searchContainer, withOffset: -5)
        
        resultsTableView.autoPinEdge(.top, to: .bottom, of: searchContainer, withOffset: 5)
        resultsTableView.autoPinEdge(toSuperviewSafeArea: .leading)
        resultsTableView.autoPinEdge(toSuperviewSafeArea: .trailing)
        resultsTableView.autoPinEdge(toSuperviewSafeArea: .bottom)
    }
    
    
    //MARK: - Styling Elements
    
    private func styleBackButton() {
        backButton.setImage(UIImage(named: "back-button"), for: .normal)
    }
    
    
    private func styleSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = .black
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = .black20
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white70
        searchBar.placeholder = LocalizedStrings.searchLocations
        
        let glassIconView = searchBar.searchTextField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        glassIconView.tintColor = .white80
    }
    
    private func styleResultsTableView() {
        resultsTableView.backgroundColor = .clear
        resultsTableView.separatorStyle = .none
    }
    
}
