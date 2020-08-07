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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUiElements()
        setupConditions()
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.setGradientBackground(colorOne: Colors.grey, colorTwo: Colors.darkNavyBlue)
    }
    
    private func numOfConditions() -> Int {
        return conditions.count
    }
    
    private func setupConditions(){
        let forecast = currentWeather.forecast
        
        conditions.append(("feels like", Temperature.celsiusToString(temp: forecast.temperature.c)))
        conditions.append(("humidity",  "\(forecast.humidity) %"))
        conditions.append(("pressure",  "\(forecast.pressure) hPa"))
    }
    
    private func setupCollectionView(){
        collectionView.dataSource = self
        
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(100)
        )
        
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 2)
        group.interItemSpacing = .fixed(20.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "WeatherConditionDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    //MARK: - UI elements setup
    
    private func setupUiElements(){
        let forecast = currentWeather.forecast
        
        title = currentWeather.name
        
        tempLabel.text = String(Temperature.celsiusToString(temp: forecast.temperature.c).dropLast(2))
        weatherDescriptionLabel.text = currentWeather.weather.description.firstCapitalized
        
        let urlString = currentWeather.weather.iconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
    
}

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


