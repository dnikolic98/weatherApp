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
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    var currentWeather: CurrentWeather!
    private var conditions: [(name: String, value: String)] = []
    
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUiElements()
        setupConditions()
        setupCollectionView()
        setupCollectionViewHeight()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.setGradientBackground(colorOne: Colors.grey, colorTwo: Colors.darkNavyBlue)
    }
    
    //MARK: CollectioView Data
    
    private func setupConditions() {
        let forecast = currentWeather.forecast
        
        conditions.append(("feels like", Temperature.celsiusToString(temp: forecast.temperature.c)))
        conditions.append(("humidity",  "\(forecast.humidity) %"))
        conditions.append(("pressure",  "\(forecast.pressure) hPa"))
        conditions.append(("wind", "\(currentWeather.wind.speed * 3.6) km/h"))
    }
    
    private func numOfConditions() -> Int {
        return conditions.count
    }
    
    private func numOfConditionRows() -> Int {
        return numOfConditions() / 2 + numOfConditions() % 2
    }
    
    //MARK: - UI elements setup
    
    private func setupUiElements(){
        let forecast = currentWeather.forecast
        
        title = currentWeather.name
        
        tempLabel.text = String(Temperature.celsiusToString(temp: forecast.temperature.c).dropLast(2))
        weatherDescriptionLabel.text = currentWeather.weather.description.firstCapitalized
        minTempLabel.text = Temperature.celsiusToString(temp: forecast.minTemperature.c)
        maxTempLabel.text = Temperature.celsiusToString(temp: forecast.maxTemperature.c)
        
        let urlString = currentWeather.weather.iconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.layer.cornerRadius = 10
        collectionView.register(UINib(nibName: "WeatherConditionDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let padding = CGFloat(20)
        
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(100)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(padding)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        section.interGroupSpacing = padding
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    private func setupCollectionViewHeight(){
        let rows = numOfConditionRows()
        let rowHeight = 100
        let padding = 20
        
        collectionViewHeightConstraint.constant = CGFloat(rowHeight * rows + padding * (rows + 1))
    }
    
}

//MARK: - CollectioView DataSource

extension DetailWeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfConditions()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! WeatherConditionDetailCollectionViewCell
        
        let condition = conditions[indexPath.row]
        cell.set(condition: condition.name, value: condition.value)
        return cell
    }
    
    
}


