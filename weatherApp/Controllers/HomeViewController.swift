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
    private let rowHeight = 100.0 as CGFloat
    private var refreshControl: UIRefreshControl!
    private var currentWeather: [CurrentWeather] = []
    
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
        
        view.setGradientBackground(colorOne: Colors.grey, colorTwo: Colors.darkNavyBlue)
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
    
    private func setupData() {
        currentWeather = []
        
        for city in Cities.allCases {
            WeatherService().fetchCurrentWeather(id: city.rawValue) { [weak self] (currentWeather) in
                guard
                    let self = self,
                    let currentWeather = currentWeather else { return }
                self.currentWeather.append(currentWeather)
                self.refreshTableView()
            }
        }
    }
    
    private func numberOfCurrentWeather() -> Int {
        return currentWeather.count
    }
    
    private func currentWeather(atIndex index: Int) -> CurrentWeather? {
        guard currentWeather.count > index else { return nil }
        
        return currentWeather[index]
    }
    
    //MARK: - UI elements setup
    
    private func setupNavigationBar(){
        // set navigationBar title and back button color, title font size and back button text
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24.0)]
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.navigationBar.tintColor = UIColor.white;
        }
        
        // remove navigationBar background
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        tableViewHeightConstraint.constant = CGFloat(0)
    }
    
    @objc private func refreshTableView() {
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
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let currentWeather = currentWeather(atIndex: indexPath.row) {
            let detailViewController = DetailWeatherViewController()
            detailViewController.currentWeather = currentWeather
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        let horizontalPadding: CGFloat = 20
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: horizontalPadding/2, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}
