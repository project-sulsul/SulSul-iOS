//
//  UICollectionView+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

extension UICollectionView {
    public enum SupplementaryViewOfKind: CustomStringConvertible {
        case header, footer
        
        public var description: String {
            switch self {
            case .header:   return UICollectionView.elementKindSectionHeader
            case .footer:   return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    public func scrollToSpecificRow(row: Int, section: Int, position: UICollectionView.ScrollPosition? = .centeredHorizontally, animated: Bool? = true) {
        guard numberOfSections > 0, numberOfItems(inSection: section) > 0 else { return }
        let indexPath = IndexPath(row: row, section: section)
        scrollToItem(at: indexPath, at: position ?? .centeredHorizontally, animated: animated ?? true)
    }
    
    public func registerCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    public func registerSupplimentaryView<T: UICollectionReusableView>(_ supplimentaryViewType: T.Type, supplementaryViewOfKind kind: SupplementaryViewOfKind) {
        register(supplimentaryViewType,
                 forSupplementaryViewOfKind: kind.description,
                 withReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeueSupplimentaryView<T: UICollectionReusableView>(_ supplimentaryViewType: T.Type, supplementaryViewOfKind kind: SupplementaryViewOfKind, indexPath: IndexPath) -> T? {
        return dequeueReusableSupplementaryView(ofKind: kind.description, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
}
