//
//  RelatedFeedViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-04.
//

import UIKit
import DesignSystem

final class RelatedFeedViewController: BaseViewController {
    var coordinator: RankingBaseCoordinator?
    
    private lazy var layout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(86))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private lazy var recommendSnackCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
//        $0.dataSource = self
//        $0.delegate = self
        $0.register(RecommendSnackCell.self, forCellWithReuseIdentifier: RecommendSnackCell.reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        addViews()
//        makeConstraints()
    }
    
    override func addViews() {
//        view.addSubview(recommendSnackCollectionView)
    }
    
    override func makeConstraints() {
//        recommendSnackCollectionView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
    }
    
    // MARK: - Custom Method
    
    private func bind() {}
}

// MARK: - Recommend Snacks CollectionView DataSource

//extension RelatedFeedViewController: UICollectionViewDataSource {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        return 0
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendSnackCell.reuseIdentifier, for: indexPath) as? RecommendSnackCell else {
//            return UICollectionViewCell()
//        }
//        
//        if let model = viewModel?.drinkDatasource.first?.ranking?[indexPath.item] {
//            print(model)
//            cell.bind(model)
//        }
//        
//        return cell
//    }
//}

// MARK: - Recommend Snacks CollectionView Delegate

//extension RelatedFeedViewController: UICollectionViewDelegate {}

