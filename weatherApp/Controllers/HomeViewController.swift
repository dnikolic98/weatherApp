//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private var currentWeather: [CurrentWeather] = []
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupData()
    }
    
    //MARK: - Data
    
    private func setupData() {
        currentWeather = []
        
        for city in Cities.allCases {
            WeatherService().fetchCurrentWeather(id: city.rawValue) { [weak self] (currentWeather) in
                guard
                    let self = self,
                    let currentWeather = currentWeather else { return }
                self.currentWeather.append(currentWeather)
                self.refresh()
            }
        }
    }
    
    private func numberOfCurrentWeather() -> Int {
        return currentWeather.count
    }
    
    private func currentWeather(atIndex index: Int) -> CurrentWeather? {
        guard currentWeather.count > index else {
            return nil
        }
        
        return currentWeather[index]
    }
    
    //MARK: - UI elements setup
    
    private func setupNavigationBar(){
        title = "WeatherApp"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.black;
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    @objc private func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}


//MARK: - TableView DataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCurrentWeather()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if let currentWeather = currentWeather(atIndex: indexPath.row){
            cell.set(withWeather: currentWeather)
        }
        
        return cell
    }
    
}

//MARK: - TableView Delegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let currentWeather = currentWeather(atIndex: indexPath.row) {
            let detailViewController = DetailWeatherViewController()
            detailViewController.currentWeather = currentWeather
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
