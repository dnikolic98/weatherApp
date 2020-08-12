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
    
    private var currentWeather: CurrentWeather?
    private var weatherConditions: [ConditionInformation] = []
    private let padding: CGFloat = 20
    private let rowHeight: CGFloat = 100
    private var numOfConditions: Int {
        weatherConditions.count
    }
    private var numOfConditionRows: Int {
        numOfConditions / 2 + numOfConditions % 2
    }
    
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    convenience init(currentWeather: CurrentWeather) {
        self.init()
        
        self.currentWeather = currentWeather
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeatherInformation()
        setupWeatherConditions()
        setupCollectionView()
        setupCollectionViewHeight()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
    }
    
    //MARK: CollectioView Data
    
    private func setupWeatherConditions() {
        guard let currentWeather = currentWeather else { return }
        
        let forecast = currentWeather.forecast
        
        let feelsLikeTemperatureValue = Int(forecast.feelsLikeTemperature.celsius)
        let windSpeedValue = currentWeather.wind.speed * 3.6
        
        let feelsLikeTemperature = ConditionInformation(title: LocalizedStrings.feelsLike, value: String(format: LocalizedStrings.temperatureValueFormat, feelsLikeTemperatureValue))
        let humidity =  ConditionInformation(title: LocalizedStrings.humidity, value: String(format: LocalizedStrings.percentageValueFormat, forecast.humidity))
        let pressure = ConditionInformation(title: LocalizedStrings.pressure, value: String(format: LocalizedStrings.pressureValueFormat, forecast.pressure))
        let windSpeed = ConditionInformation(title: LocalizedStrings.wind, value: String(format: LocalizedStrings.speedValueFormat, windSpeedValue))
        
        weatherConditions.append(feelsLikeTemperature)
        weatherConditions.append(humidity)
        weatherConditions.append(pressure)
        weatherConditions.append(windSpeed)
    }
    
    //MARK: - UI elements setup
    
    private func setWeatherInformation() {
        guard let currentWeather = currentWeather else { return }
        
        let forecast = currentWeather.forecast
        
        title = currentWeather.name
        
        tempLabel.text = String(format: LocalizedStrings.degreeValueFormat, Int(forecast.temperature.celsius))
        weatherDescriptionLabel.text = currentWeather.weather.description.firstCapitalized
        minTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, Int(forecast.minTemperature.celsius))
        maxTempLabel.text = String(format: LocalizedStrings.temperatureValueFormat, Int(forecast.maxTemperature.celsius))

        let urlString = currentWeather.weather.iconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.layer.cornerRadius = 10
        collectionView.register(UINib(nibName: WeatherConditionDetailCollectionViewCell.typeName, bundle: nil), forCellWithReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(rowHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(padding)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        section.interGroupSpacing = padding
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupCollectionViewHeight() {
        let numOfRows = numOfConditionRows
        
        collectionViewHeightConstraint.constant = rowHeight * CGFloat(numOfRows) + padding * CGFloat(numOfRows + 1)    }
    
}

//MARK: - CollectionView DataSource

extension DetailWeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfConditions
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName, for: indexPath) as! WeatherConditionDetailCollectionViewCell
        
        let condition = weatherConditions[indexPath.row]
        cell.set(condition: condition)
        return cell
    }
    
    
}
