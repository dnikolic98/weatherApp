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
    private let padding: CGFloat = 20
    private let rowHeight: CGFloat = 100
    
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    convenience init(currentWeather: CurrentWeatherViewModel) {
        self.init()
        
        self.detailWeatherPresenter = DetailWeatherPresenter(currentWeather: currentWeather)
    }
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeatherInformation()
        setupCollectionView()
        setupCollectionViewHeight()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.setGradientBackground(startColor: .grayBlueTint, endColor: .darkNavyBlue)
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
        let numOfRows = detailWeatherPresenter?.numberOfConditionRows ?? 0
        
        collectionViewHeightConstraint.constant = rowHeight * CGFloat(numOfRows) + padding * CGFloat(numOfRows + 1)
    }
    
}

//MARK: - CollectionView DataSource

extension DetailWeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailWeatherPresenter?.numberOfConditions ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionDetailCollectionViewCell.typeName, for: indexPath) as! WeatherConditionDetailCollectionViewCell
        
        if let condition = detailWeatherPresenter?.weatherCondition(atIndex: indexPath.row) {
            cell.set(conditionViewModel: condition)
        }
        return cell
    }
    
}
