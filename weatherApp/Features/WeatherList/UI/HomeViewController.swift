//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private let rowHeight = WeatherTableViewCell.height
    private var refreshControl: UIRefreshControl!
    private var currentWeatherListPresenter: CurrentWeatherListPresenter!
    private var dataDisposeBag: DisposeBag = DisposeBag()
    private var timerDisposeBag: DisposeBag = DisposeBag()
    private let dataRefreshPeriod: Int = 60 * 2
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var currentLocationView: MainInformationView!
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        currentWeatherListPresenter.handleAddLocation(assignDelegate: self)
    }
    
    convenience init(currentWeatherListPresenter: CurrentWeatherListPresenter) {
        self.init()

        self.currentWeatherListPresenter = currentWeatherListPresenter
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNavgiationBar()
        setupTableView()
        bindViewModel()
        configurePullToRefresh()
        startTimer()
        
        view.setDefaultGradient()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        refreshTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setGradientBackground()
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
    
    @objc private func bindViewModel() {
        dataDisposeBag = DisposeBag()
        
        currentWeatherListPresenter.currentWeatherData
            .subscribe(onNext: { [weak self] currentWeatherList, currentLocation in
                guard
                    let self = self,
                    let currentLocation = currentLocation
                else {
                    return
                }

                self.refreshUI(currentLocation: currentLocation)
            })
            .disposed(by: dataDisposeBag)
    }
    
    private func startTimer() {
        timerDisposeBag = DisposeBag()
        
        Observable<Int>
            .timer(.seconds(0), period: .seconds(dataRefreshPeriod), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.bindViewModel()
            })
            .disposed(by: timerDisposeBag)
    }
    
    //MARK: - UI elements setup
    
    private func styleNavgiationBar() {
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
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.typeName)
    }
    
    private func configurePullToRefresh() {
       refreshControl = UIRefreshControl()
       refreshControl.addTarget(self, action: #selector(bindViewModel), for: UIControl.Event.valueChanged)
       scrollView.refreshControl = refreshControl
    }
    
    private func refreshUI(currentLocation: CurrentWeatherViewModel) {
        DispatchQueue.main.async {
            self.currentLocationView.set(currentWeather: currentLocation)
            self.setGradientBackground()
        }
        refreshTableView()
    }
    
    private func refreshTableView() {
        DispatchQueue.main.async {
            self.refreshTableViewHeight()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func refreshTableViewHeight() {
        let rows = currentWeatherListPresenter.numberOfCurrentWeather
        
        tableViewHeightConstraint.constant = CGFloat(rows) * rowHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setGradientBackground() {
        guard let currentWeather = currentWeatherListPresenter.currentLocationWeather else { return }
        
        view.setAutomaticGradient(currentWeather: currentWeather)
    }
    
}

//MARK: - TableView DataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeatherListPresenter.numberOfCurrentWeather
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.typeName, for: indexPath) as! WeatherTableViewCell
        
        if let currentWeather = currentWeatherListPresenter.currentWeather(atIndex: indexPath.row) {
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
        
        guard let currentWeather = currentWeatherListPresenter.currentWeather(atIndex: indexPath.row) else { return }
        
        currentWeatherListPresenter.handleSelectedLocation(currentWeather: currentWeather)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let currentWeather = currentWeatherListPresenter.currentWeather(atIndex: indexPath.row) else { return }
            currentWeatherListPresenter.handleRemoveLocation(id: currentWeather.id, index: indexPath.row)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.refreshTableView()
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            CATransaction.commit()
        }
    }
    
}

extension HomeViewController: LocationSearchDelegate {
    
    func didTapNewLocation() {
        bindViewModel()
    }
    
}
