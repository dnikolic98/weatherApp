//
//  StaticWidthDistributionLayout.swift
//  weatherApp
//
//  Created by Dario Nikolic on 15/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import UIKit

extension UICollectionViewLayout {
    
    class func createStaticWidthDistributionLayout(columns: Int, padding: CGFloat, rowHeight: CGFloat) -> UICollectionViewCompositionalLayout {
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
    
}
