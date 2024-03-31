//
//  MyFeedView.swift
//  Feature
//
//  Created by 이범준 on 2024/01/08.
//

import UIKit
import Combine
import DesignSystem

class MyFeedView: UIView {
    
    private var cancelBag = Set<AnyCancellable>()
    private var viewModel: ProfileMainViewModel
    private let tabBarController: UITabBarController
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then({
        $0.registerCell(NoDataCell.self)
        $0.registerCell(MyFeedCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.dataSource = self
    })
    
    init(frame: CGRect = .zero, viewModel: ProfileMainViewModel, tabBarController: UITabBarController) {
        self.viewModel = viewModel
        self.tabBarController = tabBarController
        super.init(frame: frame)
        self.collectionView.delegate = self
        addViews()
        makeConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        viewModel.myFeedsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
    
    func addViews() {
        addSubviews([collectionView])
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 18))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in

            let itemHeight: CGFloat = self.viewModel.getMyFeedsValue().count == 0 ? 80 + 133 + 80 : 531
            let itemWidth: CGFloat = 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth),
                                                  heightDimension: .absolute(moderateScale(number: itemHeight)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(moderateScale(number: itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = 10
            
            return section
        }
    }
}

extension MyFeedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.getBeneficiaryCountryList().count + 1
        if viewModel.getMyFeedsValue().count == 0 {
            // MARK: - 빈 셀일때
            return 1
        } else {
            return viewModel.getMyFeedsValue().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.getMyFeedsValue().count == 0 {
            guard let cell = collectionView.dequeueReusableCell(NoDataCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(withType: .logInMyFeed)
            cell.nextLabel.setOpaqueTapGestureRecognizer { [weak self] in
                print("로그인하러가기")
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(MyFeedCell.self, indexPath: indexPath) else { return .init() }
            let model = viewModel.getMyFeedsValue()[indexPath.row]
            cell.bind(model)
            return cell
        }
    }
}

extension MyFeedView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking {
            tabBarController.setTabBarHidden(true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            tabBarController.setTabBarHidden(false)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tabBarController.setTabBarHidden(false)
    }
}

