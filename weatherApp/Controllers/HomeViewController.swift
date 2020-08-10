//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var currentWeather: [CurrentWeather] = []
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        refreshTableView()
    }
    
    //MARK: - Data
    
    @objc private func setupData() {
        let locationIds = Cities.allCases.map { $0.rawValue }
        
        WeatherService().fetchSeveralCurrentWeather(id: locationIds) { [weak self] (currentWeatherList) in
            guard
                let self = self,
                let currentWeatherList = currentWeatherList
                else { return }
            
            self.currentWeather = currentWeatherList
            self.refreshTableView()
        }
        
    }
    
    private func currentWeather(atIndex index: Int) -> CurrentWeather? {
        guard currentWeather.count > index else { return nil }
        
        return currentWeather[index]
    }
    
    //MARK: - UI elements setup
    
    private func setupNavigationBar() {
        title = "WeatherApp"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(setupData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: WeatherTableViewCell.typeName, bundle: nil), forCellReuseIdentifier: WeatherTableViewCell.typeName)
    }
    
    private func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}


//MARK: - TableView DataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.typeName, for: indexPath) as! WeatherTableViewCell
        
        if let currentWeather = currentWeather(atIndex: indexPath.row) {
            cell.set(withWeather: currentWeather)
        }
        
        return cell
    }
    
}

//MARK: - TableView Delegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let currentWeather = currentWeather(atIndex: indexPath.row) else { return }
        
        let detailViewController = DetailWeatherViewController(currentWeather: currentWeather)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
