//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let rowHeight = CGFloat(100.0)
    private var refreshControl: UIRefreshControl!
    private var currentWeatherList: [CurrentWeather] = []
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        refreshTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        refreshTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - TableView Data
    
    @objc private func setupData() {
        let locationIds = Cities.allCases.map { $0.rawValue }
        
        WeatherService().fetchSeveralCurrentWeather(id: locationIds) { [weak self] (currentWeatherList) in
            guard
                let self = self,
                let currentWeatherList = currentWeatherList
            else {
                return
            }
            
            self.currentWeatherList = currentWeatherList
            self.refreshTableView()
        }
    }
    
    private func numberOfCurrentWeather() -> Int {
        return currentWeatherList.count
    }
    
    private func currentWeatherList(atIndex index: Int) -> CurrentWeather? {
        return currentWeatherList.at(index)
    }
    
    //MARK: - UI elements setup
    
    private func setupNavigationBar(){
        // set navigationBar title and back button color, title font size and back button text
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24.0)]
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.navigationBar.tintColor = .white;
        }
        
        // remove navigationBar background
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(setupData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableViewHeightConstraint.constant = CGFloat(0)
        tableView.register(UINib(nibName: WeatherTableViewCell.typeName, bundle: nil), forCellReuseIdentifier: WeatherTableViewCell.typeName)
    }
    
    private func refreshTableView() {
        DispatchQueue.main.async {
            self.refreshTableViewHeight()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func refreshTableViewHeight(){
        let rows = numberOfCurrentWeather()
        
        tableViewHeightConstraint.constant = CGFloat(rows) * rowHeight
    }
    
}


//MARK: - TableView DataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCurrentWeather()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.typeName, for: indexPath) as! WeatherTableViewCell
        
        if let currentWeather = currentWeatherList(atIndex: indexPath.row) {
            cell.set(withWeather: currentWeather)
        }
        
        return cell
    }
    
}

//MARK: - TableView Delegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let currentWeather = currentWeatherList(atIndex: indexPath.row) else { return }
        
        let detailViewController = DetailWeatherViewController(currentWeather: currentWeather)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
