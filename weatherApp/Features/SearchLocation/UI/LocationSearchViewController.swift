//
//  LocationSearchViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController {
    private let presenter: LocationSearchPresenter!
    private var locationSearchView: LocationSearchView {
        return self.view as! LocationSearchView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with presenter: LocationSearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = LocationSearchView(frame: UIScreen.main.bounds)
    }
    
}
