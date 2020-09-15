//
//  DetailWeatherViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxDataSources
import Hero

class DetailWeatherViewController: UIViewController {
    
    private var detailWeatherPresenter: DetailWeatherPresenter!
    private let detailsCollectioViewRowHeight = WeatherConditionDetailCollectionViewCell.height
    private let daysCollectioViewRowHeight = SingleWeatherInformationCollectionViewCell.height
    private var refreshControl: UIRefreshControl!
    private var fiveDaysDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfSingleWeatherInformation>!
    private var conditionListDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfConditionInformation>!
    private var dataDisposeBag: DisposeBag = DisposeBag()
    private var timerDisposeBag: DisposeBag = DisposeBag()
    private var refreshDisposeBag: DisposeBag = DisposeBag()
    private var reachableDisposeBag: DisposeBag = DisposeBag()
    private let warningAnimationTime: TimeInterval = 0.25
    private let detailsNumOfColumns = 2
    private let numberOfDays = 5
    private let padding: CGFloat = 10
    private let dataRefreshPeriod: Int = 60 * 2
    
    @IBOutlet weak var noInternetWarningHeight: NSLayoutConstraint!
    @IBOutlet weak var noInternetWarningView: UserWarningView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var mainInformationView: MainInformationView!
    @IBOutlet private weak var detailsCollectionView: UICollectionView!
    @IBOutlet private weak var detailsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var daysCollectionView: UICollectionView!
    
    convenience init(detailWeatherPresenter: DetailWeatherPresenter) {
        self.init()
        self.detailWeatherPresenter = detailWeatherPresenter
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentWeather = detailWeatherPresenter.currentWeather.value {
            setWeatherInformation(currentWeather: currentWeather)
        }
        setupFiveDaysDataSource()
        setupConditionListDataSource()
        setupCollectionViews()
        bindViewModel()
        startTimer()
        configurePullToRefresh()
        setupRefreshData()
        bindReachable()
        setupHero()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainInformationView.temperatureStackView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainInformationView.temperatureStackView.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let currentWeather = detailWeatherPresenter.currentWeather.value {
            setGradientBackground(currentWeather: currentWeather)
        }
    }
    
    //MARK: - Data
    
    @objc private func bindViewModel() {
        dataDisposeBag = DisposeBag()
        
        detailWeatherPresenter.bindCurrentWeather()
            .subscribe()
            .disposed(by: dataDisposeBag)
        
        detailWeatherPresenter.bindFiveDaysList()
            .bind(to: daysCollectionView.rx.items(dataSource: fiveDaysDataSource))
            .disposed(by: dataDisposeBag)
        
        detailWeatherPresenter.weatherConditionList
            .bind(to: detailsCollectionView.rx.items(dataSource: conditionListDataSource))
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
    
    private func setupRefreshData() {
        detailWeatherPresenter.weatherData
            .subscribe(onNext: { [weak self] currentWeather, _ in
            guard
                let self = self,
                let currentWeather = currentWeather
            else {
                return
            }
                self.refreshUI(currentWeather: currentWeather)
            })
            .disposed(by: refreshDisposeBag)
    }
    
    private func setupHero() {
        hero.isEnabled = true
        guard let currentWeather = detailWeatherPresenter.currentWeather.value else { return }
        
        mainInformationView.hero.id = "\(currentWeather.id)"
        mainInformationView.locationNameLabel.hero.modifiers = [.fade]
        mainInformationView.weatherIcon.hero.modifiers = [.fade]
//        mainInformationView.temperatureStackView.hero.modifiers = [.fade]
        mainInformationView.currentTempLabel.hero.modifiers = [.fade]
        mainInformationView.weatherDescriptionLabel.hero.modifiers = [.fade]
    }
    
    //MARK: - UI elements setup
    
    private func setWeatherInformation(currentWeather: CurrentWeatherViewModel) {
        guard let currentWeather = detailWeatherPresenter.currentWeather.value else { return }
        mainInformationView.set(currentWeather: currentWeather)
    }
    
    private func setupCollectionViews() {
        setupDetailsCollectionView()
        setupDaysCollectionView()
    }
    
    private func bindReachable() {
        detailWeatherPresenter.isReachable()
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
                self.noInternetWarningHeight.constant = UserWarningView.height
                self.noInternetWarningView.layoutIfNeeded()
            })
        }
    }
    
    private func hideInternetWarning() {
        DispatchQueue.main.async {
            self.noInternetWarningView.isHidden = true
            UIView.animate(withDuration: self.warningAnimationTime, animations: {
                self.noInternetWarningHeight.constant = CGFloat(0)
                self.noInternetWarningView.layoutIfNeeded()
            })
        }
    }
    
    private func setupDetailsCollectionView() {
        let numOfRows = 2
        
        detailsCollectionView.collectionViewLayout = createCollectionViewLayout(rowHeight: detailsCollectioViewRowHeight, columns: detailsNumOfColumns)
        detailsCollectionView.layer.cornerRadius = 15
        detailsCollectionView.register(WeatherConditionDetailCollectionViewCell.self, forCellWithReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName)
        
        detailsCollectionViewHeightConstraint.constant = detailsCollectioViewRowHeight * CGFloat(numOfRows) + padding * CGFloat(numOfRows + 1)
    }
    
    private func setupDaysCollectionView() {
        daysCollectionView.collectionViewLayout = createCollectionViewLayout(rowHeight: daysCollectioViewRowHeight, columns: numberOfDays)
        daysCollectionView.layer.cornerRadius = 15
        daysCollectionView.register(SingleWeatherInformationCollectionViewCell.self, forCellWithReuseIdentifier: SingleWeatherInformationCollectionViewCell.typeName)
    }
    
    private func createCollectionViewLayout(rowHeight: CGFloat, columns: Int) -> UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(rowHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: columns)
        group.interItemSpacing = .fixed(padding)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        section.interGroupSpacing = padding
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configurePullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(bindViewModel), for: UIControl.Event.valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    private func refreshUI(currentWeather: CurrentWeatherViewModel) {
        DispatchQueue.main.async {
            self.setWeatherInformation(currentWeather: currentWeather)
            self.setGradientBackground(currentWeather: currentWeather)
            self.daysCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setGradientBackground(currentWeather: CurrentWeatherViewModel) {
        view.setAutomaticGradient(currentWeather: currentWeather)
    }
    
}
