//
//  DetailWeatherViewController.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher

class DetailWeatherViewController: UIViewController {
    
    private var detailWeatherPresenter: DetailWeatherPresenter?
    private var refreshControl: UIRefreshControl!
    private let detailsNumOfColumns = 2
    private let numberOfDays = 5
    private let padding: CGFloat = 10
    private let detailsCollectioViewRowHeight: CGFloat = 100
    private let daysCollectioViewRowHeight: CGFloat = 140
    
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var detailsCollectionView: UICollectionView!
    @IBOutlet private weak var detailsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var daysCollectionView: UICollectionView!
    
    convenience init(currentWeather: CurrentWeatherViewModel) {
        self.init()
        
        self.detailWeatherPresenter = DetailWeatherPresenter(currentWeather: currentWeather)
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeatherInformation()
        setupCollectionViews()
        bindViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
    }
    
    private func bindViewModel() {
        guard let detailWeatherPresenter = detailWeatherPresenter else { return }
        
        detailWeatherPresenter.fetchFiveDaysList() { (currentWeatherList) in
            guard let _ = currentWeatherList else {
                return
            }
            
            self.refreshCollectionView()
        }
    }
    
    //MARK: - UI elements setup
    
    private func setWeatherInformation() {
        guard let currentWeather = detailWeatherPresenter?.currentWeather else { return }
        
        title = currentWeather.name
        
        tempLabel.text = String(format: LocalizedStrings.degreeValueFormat, currentWeather.temperature)
        weatherDescriptionLabel.text = currentWeather.weatherDescription.firstCapitalized
        minTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.minTemperature)
        maxTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.maxTemperature)
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func setupCollectionViews() {
        detailsCollectionView.dataSource = self
        daysCollectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: UIControl.Event.valueChanged)
        daysCollectionView.refreshControl = refreshControl
        
        setupDetailsCollectionView()
        setupDaysCollectionView()
    }
    
    private func setupDetailsCollectionView() {
        let numOfRows = detailWeatherPresenter?.numberOfConditionRows ?? 0
        
        detailsCollectionView.collectionViewLayout = createCollectionViewLayout(rowHeight: detailsCollectioViewRowHeight, columns: detailsNumOfColumns)
        detailsCollectionView.layer.cornerRadius = 10
        detailsCollectionView.register(UINib(nibName: WeatherConditionDetailCollectionViewCell.typeName, bundle: nil), forCellWithReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName)
        
        detailsCollectionViewHeightConstraint.constant = detailsCollectioViewRowHeight * CGFloat(numOfRows) + padding * CGFloat(numOfRows + 1)
    }
    
    private func setupDaysCollectionView() {
        daysCollectionView.collectionViewLayout = createCollectionViewLayout(rowHeight: daysCollectioViewRowHeight, columns: numberOfDays)
        daysCollectionView.layer.cornerRadius = 10
        daysCollectionView.register(UINib(nibName: SingleWeatherInformationCollectionViewCell.typeName, bundle: nil), forCellWithReuseIdentifier: SingleWeatherInformationCollectionViewCell.typeName)
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
    
    @objc private func refreshCollectionView() {
        DispatchQueue.main.async {
            self.daysCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

//MARK: - CollectionView DataSource

extension DetailWeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.detailsCollectionView {
            return detailWeatherPresenter?.numberOfConditions ?? 0
        } else {
            return detailWeatherPresenter?.numberOfDays ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.detailsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName, for: indexPath) as! WeatherConditionDetailCollectionViewCell
            
            if let condition = detailWeatherPresenter?.weatherCondition(atIndex: indexPath.row) {
                cell.set(conditionViewModel: condition)
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleWeatherInformationCollectionViewCell.typeName, for: indexPath) as! SingleWeatherInformationCollectionViewCell
            
            if let weatherInfo = detailWeatherPresenter?.fiveDays(atIndex: indexPath.row) {
                cell.set(weatherInfo: weatherInfo)
            }
            return cell
        }
        
    }
    
}
