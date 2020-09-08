//
//  AddLocationFooter.swift
//  weatherApp
//
//  Created by Dario Nikolic on 07/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit
import PureLayout

class AddLocationFooter: UIView {
    
    var addButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    
}
