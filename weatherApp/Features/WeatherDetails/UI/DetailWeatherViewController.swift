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

class DetailWeatherViewController: UIViewController {
    
    private var detailWeatherPresenter: DetailWeatherPresenter!
    private let detailsCollectioViewRowHeight = WeatherConditionDetailCollectionViewCell.height
    private let daysCollectioViewRowHeight = SingleWeatherInformationCollectionViewCell.height
    private var refreshControl: UIRefreshControl!
    private var currentWeatherListPresenter: CurrentWeatherListPresenter!
    private var timerDisposeBag: DisposeBag = DisposeBag()
    private let detailsNumOfColumns = 2
    private let numberOfDays = 5
    private let padding: CGFloat = 10
    private let dataRefreshPeriod: Int = 60 * 2
    
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
        
        setWeatherInformation()
        setupCollectionViews()
        bindViewModel()
        configurePullToRefresh()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
    }
    
    //MARK: - Data
    
    @objc private func bindViewModel() {
        detailWeatherPresenter.fetchFiveDaysList() { [weak self] currentWeatherList in
            guard
                let self = self,
                currentWeatherList != nil
            else {
                return
            }
            
            self.refreshCollectionViewData()
        }
        
        detailWeatherPresenter.fetchCurrentWeather { [weak self] currentWeather in
            guard
                let self = self,
                currentWeather != nil
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.setWeatherInformation()
            }
        }
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
    
    private func setWeatherInformation() {
        let currentWeather = detailWeatherPresenter.currentWeather
        mainInformationView.set(currentWeather: currentWeather)
    }
    
    private func setupCollectionViews() {
        detailsCollectionView.dataSource = self
        daysCollectionView.dataSource = self
        
        setupDetailsCollectionView()
        setupDaysCollectionView()
    }
    
    private func setupDetailsCollectionView() {
        let numOfRows = detailWeatherPresenter?.numberOfConditionRows ?? 0
        
        detailsCollectionView.collectionViewLayout = createCollectionViewLayout(rowHeight: detailsCollectioViewRowHeight, columns: detailsNumOfColumns)
        detailsCollectionView.layer.cornerRadius = 10
        detailsCollectionView.register(WeatherConditionDetailCollectionViewCell.self, forCellWithReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName)
        
        detailsCollectionViewHeightConstraint.constant = detailsCollectioViewRowHeight * CGFloat(numOfRows) + padding * CGFloat(numOfRows + 1)
    }
    
    private func setupDaysCollectionView() {
        daysCollectionView.collectionViewLayout = createCollectionViewLayout(rowHeight: daysCollectioViewRowHeight, columns: numberOfDays)
        daysCollectionView.layer.cornerRadius = 10
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
    
    private func refreshCollectionViewData() {
        DispatchQueue.main.async {
            self.daysCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

//MARK: - CollectionView DataSource

extension DetailWeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == detailsCollectionView {
            return detailWeatherPresenter.numberOfConditions
        } else {
            return detailWeatherPresenter.numberOfDays
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == detailsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName, for: indexPath) as! WeatherConditionDetailCollectionViewCell
            
            if let condition = detailWeatherPresenter.weatherCondition(atIndex: indexPath.row) {
                cell.set(conditionViewModel: condition)
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleWeatherInformationCollectionViewCell.typeName, for: indexPath) as! SingleWeatherInformationCollectionViewCell
            
            if let weatherInfo = detailWeatherPresenter.fiveDays(atIndex: indexPath.row) {
                cell.set(weatherInfo: weatherInfo)
            }
            return cell
        }
    }
    
}
