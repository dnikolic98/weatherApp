//
//  DetailWeatherViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class DetailWeatherViewController: UIViewController {
    
    //MARK: - Properties
    
    private let warningAnimationTime: TimeInterval = 0.25
    private let detailsNumOfColumns = 2
    private let numberOfDays = 5
    private let padding: CGFloat = 10
    private let dataRefreshPeriod: Int = 60 * 2
    private let detailsCollectioViewRowHeight = WeatherConditionDetailCollectionViewCell.height
    private let daysCollectioViewRowHeight = SingleWeatherInformationCollectionViewCell.height
    private var dataDisposeBag: DisposeBag = DisposeBag()
    private var viewControllerDisposeBag: DisposeBag = DisposeBag()
    private var detailWeatherPresenter: DetailWeatherPresenter!
    private var refreshControl: UIRefreshControl!
    private var fiveDaysDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfSingleWeatherInformation>!
    private var conditionListDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfConditionInformation>!
    
    @IBOutlet private weak var noInternetWarningHeight: NSLayoutConstraint!
    @IBOutlet private weak var noInternetWarningView: UserWarningView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainInformationView: MainInformationView!
    @IBOutlet private weak var detailsCollectionView: UICollectionView!
    @IBOutlet private weak var detailsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var daysCollectionView: UICollectionView!
    
    //MARK: - Initialization
    
    convenience init(with presenter: DetailWeatherPresenter) {
        self.init()
        self.detailWeatherPresenter = presenter
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePullToRefresh()
        setWeatherInformation(currentWeather: detailWeatherPresenter.currentWeather)
        setupFiveDaysDataSource()
        setupConditionListDataSource()
        setupCollectionViews()
        bindViewModel()
        startTimer()
        bindReachable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainInformationView.temperatureStackView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainInformationView.temperatureStackView.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setGradientBackground(currentWeather: detailWeatherPresenter.currentWeather)
    }
    
    //MARK: - Data binding and timer
    
    @objc private func bindViewModel() {
        dataDisposeBag = DisposeBag()
        
        detailWeatherPresenter.fetchCurrentWeather()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] currentWeather in
                guard
                    let self = self,
                    let currentWeather = currentWeather
                else {
                    return
                }
                self.refreshUI(currentWeather: currentWeather)
            })
            .disposed(by: dataDisposeBag)
        
        detailWeatherPresenter.fetchFiveDaysList()
            .bind(to: daysCollectionView.rx.items(dataSource: fiveDaysDataSource))
            .disposed(by: dataDisposeBag)
        
        detailWeatherPresenter.weatherConditionList
            .bind(to: detailsCollectionView.rx.items(dataSource: conditionListDataSource))
            .disposed(by: dataDisposeBag)
    }
    
    private func setWeatherInformation(currentWeather: CurrentWeatherViewModel) {
        let currentWeather = detailWeatherPresenter.currentWeather
        mainInformationView.set(currentWeather: currentWeather)
    }
    
    private func startTimer() {
        Observable<Int>
            .timer(.seconds(0), period: .seconds(dataRefreshPeriod), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.bindViewModel()
            })
            .disposed(by: viewControllerDisposeBag)
    }
    
    //MARK: - RxDataSources setup
    
    private func setupFiveDaysDataSource() {
        fiveDaysDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfSingleWeatherInformation>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleWeatherInformationCollectionViewCell.typeName, for: indexPath) as! SingleWeatherInformationCollectionViewCell
                cell.set(weatherInfo: item)
                return cell
        })
    }
    
    private func setupConditionListDataSource() {
        conditionListDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfConditionInformation>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName, for: indexPath) as! WeatherConditionDetailCollectionViewCell
                cell.set(conditionViewModel: item)
                return cell
        })
    }
    
    //MARK: - Refresh setup
    
    private func configurePullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(bindViewModel), for: UIControl.Event.valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    private func refreshUI(currentWeather: CurrentWeatherViewModel) {
        self.setWeatherInformation(currentWeather: currentWeather)
        self.setGradientBackground(currentWeather: currentWeather)
        self.refreshControl.endRefreshing()
    }
    
    //MARK: - Warning setup
    
    private func bindReachable() {
        detailWeatherPresenter
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
            noInternetWarningHeight.constant = UserWarningView.height
        case false:
            noInternetWarningView.isHidden = true
            noInternetWarningHeight.constant = CGFloat(0)
        }
    }
    
    //MARK: - ColectionViews Setup
    
    private func setupCollectionViews() {
        setupDetailsCollectionView()
        setupDaysCollectionView()
    }
    
    private func setupDetailsCollectionView() {
        let numOfRows = 2
        
        detailsCollectionView.collectionViewLayout = UICollectionViewLayout.createStaticWidthDistributionLayout(columns: detailsNumOfColumns, padding: padding, rowHeight: detailsCollectioViewRowHeight)
        detailsCollectionView.layer.cornerRadius = 15
        detailsCollectionView.register(WeatherConditionDetailCollectionViewCell.self, forCellWithReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName)
        
        detailsCollectionViewHeightConstraint.constant = detailsCollectioViewRowHeight * CGFloat(numOfRows) + padding * CGFloat(numOfRows + 1)
    }
    
    private func setupDaysCollectionView() {
        daysCollectionView.collectionViewLayout = UICollectionViewLayout.createStaticWidthDistributionLayout(columns: numberOfDays, padding: padding, rowHeight: daysCollectioViewRowHeight)
        daysCollectionView.layer.cornerRadius = 15
        daysCollectionView.register(SingleWeatherInformationCollectionViewCell.self, forCellWithReuseIdentifier: SingleWeatherInformationCollectionViewCell.typeName)
    }
    
    //MARK: - Gradient setup
    
    private func setGradientBackground(currentWeather: CurrentWeatherViewModel) {
        view.setAutomaticGradient(currentWeather: currentWeather)
    }
    
}
