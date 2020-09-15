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
    private var reachableDisposeBag: DisposeBag = DisposeBag()
    private var locationsDisposeBag: DisposeBag = DisposeBag()
    private let dataRefreshPeriod: Int = 60 * 2
    private let warningAnimationTime: TimeInterval = 0.25
    
    @IBOutlet weak var noInternetViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noLocationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noLocationWarningView: UserWarningView!
    @IBOutlet weak var noInternetWarningView: UserWarningView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var currentLocationView: MainInformationView!
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        currentWeatherListPresenter.handleAddLocation()
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
    
    private func bindLocationsEnabled() {
        currentWeatherListPresenter.areLocationsEnabled()
            .subscribe(onNext: { [weak self] enabled in
                guard let self = self else { return }
                guard enabled else {
                    self.showLocationsWarning(warning: LocalizedStrings.disabledLocationsWarning)
                    return
                }
                
                guard self.currentWeatherListPresenter.checkLocationsAllowed() else {
                    self.showLocationsWarning(warning: LocalizedStrings.authLocationsWarning)
                    return
                }
                
                self.hideLocationsWarning()
            })
            .disposed(by: locationsDisposeBag)
    }
    
    private func showLocationsWarning(warning: String) {
        DispatchQueue.main.async {
            self.noLocationWarningView.setWarning(warningText: warning)
            self.noLocationWarningView.isHidden = false
            UIView.animate(withDuration: self.warningAnimationTime, animations: {
                self.noLocationViewHeight.constant = UserWarningView.height
                self.noLocationWarningView.layoutIfNeeded()
            })
        }
    }
    
    private func hideLocationsWarning() {
        DispatchQueue.main.async {
            self.noLocationWarningView.isHidden = true
            UIView.animate(withDuration: self.warningAnimationTime, animations: {
                self.noLocationViewHeight.constant = CGFloat(0)
                self.noLocationWarningView.layoutIfNeeded()
            })
        }
    }
    
    private func bindReachable() {
        currentWeatherListPresenter.isReachable()
            .subscribe(onNext: { [weak self] reachable in
                guard let self = self else { return }
                guard reachable else {
                    self.showInternetWarning()
                    return
                }
                self.hideInternetWarning()
            })
            .disposed(by: reachableDisposeBag)
    }
    
    private func showInternetWarning() {
        DispatchQueue.main.async {
            self.noInternetWarningView.setWarning(warningText: LocalizedStrings.noInternetWarning)
            self.noInternetWarningView.isHidden = false
            UIView.animate(withDuration: self.warningAnimationTime, animations: {
                self.noInternetViewHeight.constant = UserWarningView.height
                self.noInternetWarningView.layoutIfNeeded()
            })
        }
    }
    
    private func hideInternetWarning() {
        DispatchQueue.main.async {
            self.noInternetWarningView.isHidden = true
            UIView.animate(withDuration: self.warningAnimationTime, animations: {
                self.noInternetViewHeight.constant = CGFloat(0)
                self.noInternetWarningView.layoutIfNeeded()
            })
        }
    }
    
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
        refreshTableView(completion: { })
    }
    
    private func refreshTableViewHeight(completion: @escaping (() -> Void)) {
        let rows = currentWeatherListPresenter.numberOfCurrentWeather
        
        tableViewHeightConstraint.constant = CGFloat(rows) * rowHeight
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.tableView.reloadData()
        }, completion: { completed in
            completion()
        })
    }
    
    private func refreshTableView(completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            self.refreshTableViewHeight(completion: { completion() })
            self.refreshControl.endRefreshing()
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
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.refreshTableView(completion: {
                    self.currentWeatherListPresenter.handleRemoveLocation(id: currentWeather.id)
                })
            }
            currentWeatherListPresenter.currentWeatherRemoveItem(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CATransaction.commit()
        }
    }
    
}
