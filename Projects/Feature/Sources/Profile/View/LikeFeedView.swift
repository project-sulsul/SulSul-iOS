////
////  likeFeedView.swift
////  Feature
////
////  Created by 이범준 on 2024/01/08.
////

import UIKit
import Combine
import DesignSystem

class LikeFeedView: UIView {
    
    private var cancelBag = Set<AnyCancellable>()
    private var viewModel: ProfileMainViewModel
    private let tabBarController: UITabBarController
    private var likeFeedState: MyFeedState?
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then({
        $0.registerCell(NoDataCell.self)
        $0.registerCell(LikeFeedCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
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
    
    private func bind() {
        viewModel.likeFeedsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { response in
                if response.count == 0 {
                    self.likeFeedState = .loginFeedNotExist
                } else {
                    self.likeFeedState = .loginFeedExist
                }
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
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self = self else { return nil }
            
            let itemWidth: CGFloat
            let itemHeight: CGFloat
            
            switch likeFeedState {
            case .loginFeedExist:
                itemHeight = 220
                itemWidth = 1/2
            case .loginFeedNotExist:
                itemHeight = 400
                itemWidth = 1
            case .notLogin:
                itemHeight = 400
                itemWidth = 1
            case nil:
                return nil
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth),
                                                  heightDimension: .absolute(moderateScale(number: itemHeight)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(moderateScale(number: itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = moderateScale(number: 10)
            
            return section
        }
    }
    
    func updateState(_ likeFeedState: MyFeedState) {
        self.likeFeedState = likeFeedState
        collectionView.reloadData()
    }
    
    func moveToTabBarIndex(index: Int) {
        self.tabBarController.selectedIndex = index
    }
}

extension LikeFeedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch likeFeedState {
        case .loginFeedExist:
            return viewModel.getLikeFeedsValue().count
        case .loginFeedNotExist:
            return 1
        case .notLogin:
            return 1
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch likeFeedState {
        case .loginFeedExist:
            guard let cell = collectionView.dequeueReusableCell(LikeFeedCell.self, indexPath: indexPath) else { return .init() }
            let model = viewModel.getLikeFeedsValue()[indexPath.row]
            cell.bind(model)
            cell.containerView.setOpaqueTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                self.viewModel.sendDetailFeed(model.feedId)
            }
            return cell
        case .loginFeedNotExist:
            guard let cell = collectionView.dequeueReusableCell(NoDataCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(withType: .likeFeed)
            cell.nextLabel.setOpaqueTapGestureRecognizer { [weak self] in
                self?.moveToTabBarIndex(index: 3)
            }
            
            return cell
        case .notLogin:
            guard let cell = collectionView.dequeueReusableCell(NoDataCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(withType: .logOutMyFeed)
            cell.nextLabel.setOpaqueTapGestureRecognizer { [weak self] in
                print("로그인하러 가기")
                guard let selfRef = self else { return }
                selfRef.viewModel.sendLoginButtonIsTapped()
            }
            
            return cell
        case .none:
            guard let cell = collectionView.dequeueReusableCell(NoDataCell.self, indexPath: indexPath) else { return .init() }
            
            return cell
            
        }
    }
}

extension LikeFeedView: UIScrollViewDelegate {
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
