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
    
    //MARK: - Properties
    
    static var typeName: String {
        String(describing: self)
    }
    
    var headerLabel: UILabel!
    var mainInformationLabel: UILabel!
    var translucentView: UIView!
    var weatherIcon: UIImageView!
    
    //MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    //MARK: - Set data
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = ""
        mainInformationLabel.text = ""
        weatherIcon.image = nil
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
