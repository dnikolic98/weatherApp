//
//  LocationSearchView+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

extension LocationSearchView: DesignProtocol {
    
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
        
        loadingIndicator = UIActivityIndicatorView()
        addSubview(loadingIndicator)
    }
    
    func styleViews() {
        styleBackButton()
        styleSearchBar()
        styleResultsTableView()
        styleLoadingIndicator()
    }
    
    func defineLayoutForViews() {
        let offset: CGFloat = 5
        let defaultSize: CGFloat = 50
        
        searchContainer.autoSetDimension(.height, toSize: defaultSize)
        searchContainer.autoPinEdge(toSuperviewSafeArea: .leading)
        searchContainer.autoPinEdge(toSuperviewSafeArea: .trailing)
        searchContainer.autoPinEdge(toSuperviewSafeArea: .top)
        
        backButton.autoPinEdge(.leading, to: .leading, of: searchContainer, withOffset: offset)
        backButton.autoPinEdge(.top, to: .top, of: searchContainer, withOffset: offset)
        backButton.autoPinEdge(.bottom, to: .bottom, of: searchContainer, withOffset: -offset)
        
        searchBar.autoPinEdge(.trailing, to: .trailing, of: searchContainer, withOffset: -offset)
        searchBar.autoPinEdge(.leading, to: .trailing, of: backButton)
        searchBar.autoPinEdge(.top, to: .top, of: searchContainer, withOffset: offset)
        searchBar.autoPinEdge(.bottom, to: .bottom, of: searchContainer, withOffset: -offset)
        
        resultsTableView.autoPinEdge(.top, to: .bottom, of: searchContainer, withOffset: offset)
        resultsTableView.autoPinEdge(toSuperviewSafeArea: .leading)
        resultsTableView.autoPinEdge(toSuperviewSafeArea: .trailing)
        resultsTableView.autoPinEdge(toSuperviewSafeArea: .bottom)
        
        loadingIndicator.autoSetDimension(.height, toSize: defaultSize)
        loadingIndicator.autoSetDimension(.width, toSize: defaultSize)
        loadingIndicator.autoCenterInSuperview()
    }
    
    
    //MARK: - Styling Elements
    
    private func styleBackButton() {
        backButton.setImage(UIImage(named: "back-button"), for: .normal)
    }
    
    private func styleLoadingIndicator() {
        loadingIndicator.style = .large
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
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
