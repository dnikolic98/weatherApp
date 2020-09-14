//
//  UserWarningView.swift
//  weatherApp
//
//  Created by Dario Nikolic on 14/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

class UserWarningView: UIView {
    
    var warningInfo: UILabel!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         buildViews()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         buildViews()
    }
    
    func setWarning(warningText: String) {
        warningInfo.text = warningText
    }
    
}
