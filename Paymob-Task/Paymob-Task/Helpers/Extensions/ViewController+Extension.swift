//
//  ViewController+Extension.swift
//  Paymob-Task
//
//  Created by iOSAYed on 07/07/2024.
//

import Foundation
import UIKit

extension UIViewController {
    static func generateCollectionLayout() -> UICollectionViewCompositionalLayout {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/6))
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
           
           let section = NSCollectionLayoutSection(group: group)
           return UICollectionViewCompositionalLayout(section: section)
       }

}
