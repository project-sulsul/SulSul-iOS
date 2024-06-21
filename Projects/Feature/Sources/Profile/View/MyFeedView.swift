//
//  MyFeedView.swift
//  Feature
//
//  Created by 이범준 on 2024/01/08.
//

import UIKit
import Combine
import DesignSystem

enum MyFeedState {
    case loginFeedExist
    case loginFeedNotExist
    case notLogin
}

protocol MyFeedViewDelegate: AnyObject {
    func didTapNextLabel()
}

class MyFeedView: UIView {
    weak var delegate: MyFeedViewDelegate?
    
    private var cancelBag = Set<AnyCancellable>()
    private var viewModel: ProfileMainViewModel
    private let tabBarController: UITabBarController
    private var myFeedState: MyFeedState?
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then({
        $0.registerCell(NoDataCell.self)
        $0.registerCell(MyFeedCell.self)
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
        viewModel.myFeedsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { response in
                if response.count == 0 {
                    self.myFeedState = .loginFeedNotExist
                } else {
                    self.myFeedState = .loginFeedExist
                }
                self.collectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
    
    private func addViews() {
        addSubviews([collectionView])
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 18))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func updateState(_ myFeedState: MyFeedState) {
        self.myFeedState = myFeedState
        collectionView.reloadData()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            let itemWidth: CGFloat = 1
            let itemHeight: CGFloat
            
            switch self?.myFeedState {
            case .loginFeedExist:
                itemHeight = 611
            case .loginFeedNotExist, .notLogin:
                itemHeight = 400
            case nil:
                itemHeight = 0
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth),
                                                  heightDimension: .estimated(moderateScale(number: itemHeight)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            switch self?.myFeedState {
            case .loginFeedExist, .loginFeedNotExist:
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
            case .notLogin, .none:
                break
            }
        
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(moderateScale(number: itemHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = 10
            
            return section
        }
    }
}

extension MyFeedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch myFeedState {
        case .loginFeedExist:
            return viewModel.getMyFeedsValue().count
        case .loginFeedNotExist:
            return 1
        case .notLogin:
            return 1
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch myFeedState {
        case .loginFeedExist:
            guard let cell = collectionView.dequeueReusableCell(MyFeedCell.self, indexPath: indexPath) else { return .init() }
            let model = viewModel.getMyFeedsValue()[indexPath.row]
            cell.bind(model)
            
            cell.containerView.setOpaqueTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                self.viewModel.sendDetailFeed(model.feedId)
            }
            
            return cell
        case .loginFeedNotExist:
            guard let cell = collectionView.dequeueReusableCell(NoDataCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(withType: .logInMyFeed)
            cell.nextLabel.setOpaqueTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                
                self.delegate?.didTapNextLabel()
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

