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
    
    
    class func createScrollingFixedWidthLayout(itemsAtOnce: Int, numOfItems: Int, padding: CGFloat, rowWidth: CGFloat, rowHeight: CGFloat) -> UICollectionViewCompositionalLayout {
        let estimatedItemWidth = rowWidth / CGFloat(itemsAtOnce)
        let scrollingWidth = (estimatedItemWidth - padding) * CGFloat(numOfItems) + 2 * padding
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.estimated(estimatedItemWidth),
            heightDimension: NSCollectionLayoutDimension.estimated(rowHeight)
        )
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.estimated(scrollingWidth),
            heightDimension: NSCollectionLayoutDimension.estimated(rowHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: numOfItems)
        group.interItemSpacing = .fixed(padding)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        section.interGroupSpacing = padding
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
