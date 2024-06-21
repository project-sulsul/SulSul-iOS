//
//  RankingDrinkViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import UIKit
import Combine
import DesignSystem

final class RankingDrinkViewController: BaseViewController {
    // MARK: - Properties
    //
    var coordinator: RankingBaseCoordinator?
    var viewModel: RankingDrinkViewModel?
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Components
    //
    private lazy var rankingDrinkCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.register(NoChangeRankingDrinkCell.self, forCellWithReuseIdentifier: NoChangeRankingDrinkCell.reuseIdentifier)
        $0.dataSource = self
    }
    
    private lazy var layout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
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
    
    // MARK: - ViewController Life-cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.addViews()
        self.makeConstraints()
    }
    
    override func addViews() {
        self.view.addSubview(rankingDrinkCollectionView)
    }
    
    override func makeConstraints() {
        self.rankingDrinkCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Initializer
    //
    init() {
        self.viewModel = RankingDrinkViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Method
//
extension RankingDrinkViewController {
    private func bind() {
        self.viewModel?.requestRankingAlcohol()
        
        self.viewModel?
            .rankingDrinkPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.rankingDrinkCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - UICollectionView DataSource
//
extension RankingDrinkViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.viewModel?.drinkDatasourceCount() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoChangeRankingDrinkCell.reuseIdentifier, for: indexPath) as? NoChangeRankingDrinkCell else {
            return UICollectionViewCell()
        }
        
        if let model = self.viewModel?.getDrinkDatasource(to: indexPath) { cell.bind(model) }
        
        return cell
    }
}
