//
//  SingleWeatherInformationCollectionViewCellCollectionViewCell.swift
//  weatherApp
//
//  Created by Dario Nikolic on 12/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import Kingfisher

class SingleWeatherInformationCollectionViewCell: UICollectionViewCell {
    
    static var typeName: String {
        String(describing: self)
    }
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var mainInformationLabel: UILabel!
    @IBOutlet weak var cellTranslucentView: UIView!
    
    override func awakeFromNib() {
        cellTranslucentView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = ""
        mainInformationLabel.text = ""
        weatherIcon?.image = nil
    }

    func set(weatherInfo: SingleWeatherInformationViewModel) {
        headerLabel.text = weatherInfo.header
        mainInformationLabel.text = weatherInfo.body
        
        let urlString = weatherInfo.iconUrlString
        if let url = URL(string: urlString) {
            weatherIcon.kf.setImage(with: url)
        }
    }
}
