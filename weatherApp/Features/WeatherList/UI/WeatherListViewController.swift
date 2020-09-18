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

class WeatherListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let dataRefreshPeriod: Int = 60 * 2
    private let warningAnimationTime: TimeInterval = 0.25
    private let rowHeight = WeatherTableViewCell.height
    private var dataDisposeBag: DisposeBag = DisposeBag()
    private var viewControllerDisposeBag: DisposeBag = DisposeBag()
    private var refreshControl: UIRefreshControl!
    private var currentWeatherListPresenter: WeatherListPresenter!
    
    @IBOutlet private weak var noInternetViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var noLocationViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var noLocationWarningView: UserWarningView!
    @IBOutlet private weak var noInternetWarningView: UserWarningView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var currentLocationView: MainInformationView!
    @IBOutlet private weak var addLocationButton: UIButton!
    
    //MARK: - IBActions
    
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        currentWeatherListPresenter.handleAddLocation()
    }
    
    //MARK: - Initialization
    
    convenience init(with presenter: WeatherListPresenter) {
        self.init()

        self.currentWeatherListPresenter = presenter
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePullToRefresh()
        styleNavgiationBar()
        setupTableView()
        bindViewModel()
        startTimer()
        bindReachable()
        bindLocationsEnabled()
        
        view.setDefaultGradient()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Data binding and timer
    
    @objc private func bindViewModel() {
        dataDisposeBag = DisposeBag()
        
        currentWeatherListPresenter
            .currentWeatherData
            .observeOn(MainScheduler.instance)
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
        viewControllerDisposeBag = DisposeBag()
        
        Observable<Int>
            .timer(.seconds(0), period: .seconds(dataRefreshPeriod), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.bindViewModel()
            })
            .disposed(by: viewControllerDisposeBag)
    }
    
    //MARK: - TableView setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.typeName)
    }
    
    //MARK: - Gradient Setup
    
    private func setGradientBackground() {
        guard let currentWeather = currentWeatherListPresenter.currentLocationWeather else { return }
        view.setAutomaticGradient(currentWeather: currentWeather)
    }
    
    //MARK: - Warning setup
    
    private func bindLocationsEnabled() {
        currentWeatherListPresenter
            .areLocationsEnabled
            .subscribe(onNext: { [weak self] enabled in
                guard let self = self else { return }
                guard enabled else {
                    self.showLocationsWarning(!enabled, warning: LocalizedStrings.disabledLocationsWarning)
                    return
                }
                
                let allowed = self.currentWeatherListPresenter.areLocationsAllowed
                self.showLocationsWarning(!allowed, warning: LocalizedStrings.authLocationsWarning)
            })
            .disposed(by: viewControllerDisposeBag)
    }
    
    private func showLocationsWarning(_ showWarning: Bool, warning: String) {
        switch showWarning {
        case true:
            noLocationWarningView.setWarning(warningText: warning)
            noLocationWarningView.isHidden = false
            UIView.animate(withDuration: warningAnimationTime, animations: {
                self.noLocationViewHeight.constant = UserWarningView.height
                self.noLocationWarningView.layoutIfNeeded()
            })
        case false:
            noLocationWarningView.isHidden = true
            UIView.animate(withDuration: warningAnimationTime, animations: {
                self.noLocationViewHeight.constant = CGFloat(0)
                self.noLocationWarningView.layoutIfNeeded()
            })
        }
    }
    
    private func bindReachable() {
        currentWeatherListPresenter
            .isReachable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] reachable in
                self?.showInternetWarning(!reachable)
            })
            .disposed(by: viewControllerDisposeBag)
    }
    
    private func showInternetWarning(_ showWarning: Bool) {
        switch showWarning {
        case true:
            noInternetWarningView.setWarning(warningText: LocalizedStrings.noInternetWarning)
            noInternetWarningView.isHidden = false
            UIView.animate(withDuration: warningAnimationTime, animations: {
                self.noInternetViewHeight.constant = UserWarningView.height
                self.noInternetWarningView.layoutIfNeeded()
            })
        case false:
            noInternetWarningView.isHidden = true
            noInternetWarningView.isHidden = true
            UIView.animate(withDuration: warningAnimationTime, animations: {
                self.noInternetViewHeight.constant = CGFloat(0)
                self.noInternetWarningView.layoutIfNeeded()
            })
        }
    }
    
    //MARK: - Refresh setup
    
    private func configurePullToRefresh() {
       refreshControl = UIRefreshControl()
       refreshControl.addTarget(self, action: #selector(bindViewModel), for: UIControl.Event.valueChanged)
       scrollView.refreshControl = refreshControl
    }
    
    private func refreshUI(currentLocation: CurrentWeatherViewModel) {
        self.currentLocationView.set(currentWeather: currentLocation)
        self.setGradientBackground()
        
        refreshTableView()
    }
    
    private func refreshTableView() {
        refreshTableViewHeight()
        refreshControl.endRefreshing()
    }
    
    private func refreshTableViewHeight() {
        let rows = currentWeatherListPresenter.numberOfCurrentWeather

        tableViewHeightConstraint.constant = CGFloat(rows) * rowHeight
        UIView.animate(withDuration: 0.5) {
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Navigation Bar styling
    
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
    
}

//MARK: - TableView DataSource

extension WeatherListViewController: UITableViewDataSource {
    
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

extension WeatherListViewController: UITableViewDelegate {
    
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
            
            currentWeatherListPresenter.handleRemoveLocation(id: currentWeather.id)
        }
    }
    
}
