//
//  UserTagCollectionView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-19.
//

import UIKit
import DesignSystem

final class UserTagCollectionView: UICollectionView {
    // MARK: - Properites
    //
    private var userTags: [String] = []
    
    // MARK: - Initializer
    //
    init(frame: CGRect) {
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 8
            $0.minimumInteritemSpacing = 8
            $0.sectionInset = .zero
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.register(UserTagCell.self, forCellWithReuseIdentifier: UserTagCell.reuseIdentifier)
        self.contentInsetAdjustmentBehavior = .always
        self.contentInset = .zero
        self.backgroundColor = .clear
        self.isScrollEnabled = false
        self.dataSource = self
        self.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Method
//
extension UserTagCollectionView {
    func bind(_ tags: [String]) {
        self.userTags = tags
        self.reloadData()
    }
}

// MARK: - UICollectionView DataSource
//
extension UserTagCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return userTags.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTagCell.reuseIdentifier, for: indexPath) as? UserTagCell
        else { return .init() }
        
        let tag = userTags[indexPath.item]
        
        cell.bind(withUserTag: tag)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate
//
extension UserTagCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTagCell.reuseIdentifier, for: indexPath) as? UserTagCell
        else { return .init() }
        
        cell.tagLabel.text = userTags[indexPath.item]
        cell.tagLabel.sizeToFit()
        
        let cellWidth = cell.tagLabel.frame.size.width
        let cellHeight = cell.tagLabel.frame.size.height

        // width: tagLabel.frame.size + 좌우 여백
        // height: tagLabel.frame.size + 상하 여백
        return CGSize(width: cellWidth + 16, height: cellHeight + 8)
    }
}
