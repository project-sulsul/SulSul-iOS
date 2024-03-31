//
//  RankingDrinkViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import Combine
import UIKit
import DesignSystem

/// 술 순위를 보여주는 뷰 컨트롤러
final class RankingDrinkViewController: BaseViewController {
    var coordinator: RankingBaseCoordinator?
    var viewModel: RankingDrinkViewModel?
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var rankingDrinkCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(RankingDrinkCell.self, forCellWithReuseIdentifier: RankingDrinkCell.reuseIdentifier)
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
        
        viewModel = RankingDrinkViewModel()
        
        bind()
        addViews()
        makeConstraints()
    }
    
    override func addViews() {
        view.addSubview(rankingDrinkCollectionView)
    }
    
    override func makeConstraints() {
        rankingDrinkCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    private func bind() {
        viewModel?.requestRankingAlcohol()
        
        viewModel?
            .rankingDrinkPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.rankingDrinkCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - Drink CollectionView DataSource

extension RankingDrinkViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel?.drinkDatasourceCount() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingDrinkCell.reuseIdentifier, for: indexPath) as? RankingDrinkCell else {
            return UICollectionViewCell()
        }
        
        if let model = viewModel?.getDrinkDatasource(to: indexPath) { cell.bind(model) }
        
        return cell
    }
}

// MARK: - Drink CollectionView Delegate

extension RankingDrinkViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
//        self.coordinator?.moveTo(appFlow: TabBarFlow.ranking(.detailDrink), userData: nil)
        #warning("술 상세 화면 MVP에서 제외")
    }
}
