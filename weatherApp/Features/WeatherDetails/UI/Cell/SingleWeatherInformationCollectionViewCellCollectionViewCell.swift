//
//  SingleWeatherInformationCollectionViewCellCollectionViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 12/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher

class SingleWeatherInformationCollectionViewCellCollectionViewCell: UICollectionViewCell {
    
    static var typeName: String {
        String(describing: self)
    }
    
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var mainInformationLabel: UILabel!
    @IBOutlet weak var cellTranslucentView: UIView!
    
    override func awakeFromNib() {
        cellTranslucentView.layer.cornerRadius = 8
    }

    func set(currentWeather: CurrentWeatherViewModel) {
//        mainInformationLabel.text = String(format: LocalizedStrings.temperatureValueFormat, currentWeather.temperature)
        mainInformationLabel.text = "28°\n23°"
        
        let urlString = currentWeather.weatherIconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
}
