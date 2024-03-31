//
//  RankingCombinationViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import Combine
import UIKit

/// 술 + 안주를 보여주는 뷰 컨트롤러
final class RankingCombinationViewController: BaseViewController {
    var coordinator: RankingBaseCoordinator?
    var viewModel: RankingCombinationViewModel?
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var rankingCombinationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(RankingCombinationCell.self, forCellWithReuseIdentifier: RankingCombinationCell.reuseIdentifier)
    }
    
    private lazy var layout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(86))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RankingCombinationViewModel()
        
        bind()
        addViews()
        makeConstraints()
    }
    
    override func addViews() {
        view.addSubview(rankingCombinationCollectionView)
    }
    
    override func makeConstraints() {
        rankingCombinationCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method

    private func bind() {
        viewModel?.requestRankingCombination()
        
        viewModel?
            .rankingCombinationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.rankingCombinationCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - Combination CollectionView DataSource

extension RankingCombinationViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel?.combinationDatasourceCount() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingCombinationCell.reuseIdentifier, for: indexPath) 
                as? RankingCombinationCell else { return UICollectionViewCell() }
        
        if let model = viewModel?.getCombinationDatasource(to: indexPath) { cell.bind(model) }
        
        return cell
    }
}

// MARK: - Combination CollectionView Delegate

extension RankingCombinationViewController: UICollectionViewDelegate {
    // 필요한 경우 사용
}
