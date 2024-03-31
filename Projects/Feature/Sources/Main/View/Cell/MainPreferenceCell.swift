//
//  PreferenceCell.swift
//  Feature
//
//  Created by 이범준 on 2/18/24.
//

import UIKit
import DesignSystem

final class MainPreferenceCell: UICollectionViewCell {
    
    private var alcoholFeed: [AlcoholFeed.Feed] = []
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.registerCell(MainPreferenceDetailCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addViews() {
        addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(moderateScale(number: 277)), heightDimension: .absolute(moderateScale(number: 323)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: moderateScale(number: 16))
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(moderateScale(number: 277)), heightDimension: .absolute(moderateScale(number: 323)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
    
    func alcoholBind(_ model: [AlcoholFeed.Feed]) {
        alcoholFeed = model
        collectionView.reloadData()
    }
}

extension MainPreferenceCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alcoholFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MainPreferenceDetailCell.self, indexPath: indexPath) else { return .init() }
        cell.bind(alcoholFeed[indexPath.item])
        return cell
    }
}
