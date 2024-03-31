//
//  DetailFeedRelatedCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import UIKit
import DesignSystem

final class DetailFeedRelatedCell: UICollectionViewCell {
    static let reuseIdentifier: String = "DetailFeedRelatedCell"
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: 173, height: 220)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 7
    }
    
    private lazy var relatedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(RelatedCell.self, forCellWithReuseIdentifier: RelatedCell.reuseIdentifier)
        $0.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(relatedCollectionView)
    }
    
    private func makeConstraints() {
        relatedCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension DetailFeedRelatedCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        // 임시로 넣음
        return 6
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedCell.reuseIdentifier, for: indexPath) as? RelatedCell else { return UICollectionViewCell() }
        
        return cell
    }
}
