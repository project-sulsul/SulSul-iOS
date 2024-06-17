//
//  MainPageViewController.swift
//  Feature
//
//  Created by 이범준 on 2/18/24.
//

import UIKit
import DesignSystem
import Service
import Combine
import Kingfisher

public final class MainPageViewController: BaseViewController, HomeBaseCoordinated {
    
    var coordinator: HomeBaseCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    private let viewModel: MainPageViewModel = MainPageViewModel() // 수정
    
    private lazy var topHeaderView = UIView()
    
    private lazy var searchTouchableIamgeView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_search")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(collectionViewIsRefreshed) , for: .valueChanged)
        
        return refreshControl
    }()
    
    private lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.registerSupplimentaryView(MainPreferenceHeaderView.self,
                                     supplementaryViewOfKind: .header)
        $0.registerSupplimentaryView(MainLikeHeaderView.self,
                                     supplementaryViewOfKind: .header)
        $0.registerCell(MainPreferenceCell.self)
        $0.registerCell(MainNoPreferenceCell.self)
        $0.registerCell(MainLikeCell.self)
        $0.registerCell(MainDifferenceCell.self)
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.refreshControl = refreshControl
    }
    
//    init(viewModel: MainPageViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
        bind()
        
        searchTouchableIamgeView.onTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.search), userData: nil)
        }
    }
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          mainCollectionView])
        
        topHeaderView.addSubviews([searchTouchableIamgeView])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        searchTouchableIamgeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        StaticValues.isLoggedInPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                viewModel.getUserInfo()
            }.store(in: &cancelBag)
        
        viewModel.userInfoPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                if result.status == UserInfoStatus.notLogin.rawValue { // MARK: - 로그인 하지 않은 유저
                    viewModel.getPopularFeeds()
                    viewModel.getDifferenceFeeds()
                    viewModel.getFeedsByAlcohol()
                    if StaticValues.isFirstLaunch {
                        self.tabBarController?.setTabBarHidden(true, animated: false)
                        self.showBottomSheetAlertView(bottomSheetAlertType: .verticalTwoButton,
                                                      title: "취향을 알려주지 않을래?",
                                                      submitLabel: "취향 등록하기!",
                                                      cancelLabel: "아직 괜찮아요",
                                                      description: "술, 안주 취향을 알려주시면 딱 맞춰 추천 해드려요.\n등록하신 취향은 언제든지 수정할 수 있어요.",
                                                      submitCompletion: { self.coordinator?.moveTo(appFlow: TabBarFlow.auth(.login), userData: nil)},
                                                      cancelCompletion: { self.tabBarController?.setTabBarHidden(false) })
                        StaticValues.isFirstLaunch = false
                    } else {
                        StaticValues.isFirstLaunch = false
                    }
                } else if result.status == UserInfoStatus.banned.rawValue { // MARK: - 밴된 유저
                    
                } else { // MARK: - 로그인한 유저
                    viewModel.getPopularFeeds()
                    viewModel.getDifferenceFeeds()
                    viewModel.getPreferenceFeeds()
                }
            }.store(in: &cancelBag)
        
        viewModel.selectedAlcoholFeedPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.mainCollectionView.reloadData()
            }.store(in: &cancelBag)
        
        viewModel.completeAllFeedPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.mainCollectionView.reloadData()
            }.store(in: &cancelBag)
        
        viewModel.getUserInfo()
    }
    
    @objc
    private func collectionViewIsRefreshed() {
        viewModel.getPopularFeeds()
        viewModel.getDifferenceFeeds()
        if StaticValues.isLoggedIn.value {
            viewModel.getPreferenceFeeds()
        } else {
            viewModel.getFeedsByAlcohol()
        }
        refreshControl.endRefreshing()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
                var itemHeight: CGFloat = 0
                
                itemHeight = 323
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight + 24)))
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight + 24)))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                    
                var headerSize: NSCollectionLayoutSize

                if StaticValues.isLoggedIn.value {
                    headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: 80)))
                } else {
                    headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: 118)))
                }
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                
                return section
            case 1:
                var itemHeight: CGFloat = 0
                
                itemHeight = 292
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                    
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(moderateScale(number: 78 + 12 + 16)))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                return section
            case 2:
                var itemHeight: CGFloat = 0
                
                itemHeight = 416.86
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: itemHeight)))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                    
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(moderateScale(number: 112)))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
 
                section.boundarySupplementaryItems = [header]
                return section
            default:
                return nil
            }
        }
    }
}

extension MainPageViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 { // MARK: - 좋아요 많은 조합
            if viewModel.getPopularFeedsValue().count > 2 {
                return 2
            } else {
                return viewModel.getPopularFeedsValue().count
            }
        } else {
            return viewModel.getDifferenceFeedsValue().count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if viewModel.getSelectedAlcoholFeedsValue().count == 0 {
                if StaticValues.isLoggedIn.value == false { // MARK: - 로그아웃 유저
                    guard let cell = collectionView.dequeueReusableCell(MainNoPreferenceCell.self, indexPath: indexPath) else { return .init() }
                    cell.bind(nickName: nil, preference: viewModel.getSelectedAlcoholValue())
                    cell.registerButton.setOpaqueTapGestureRecognizer { [weak self] in
                        self?.coordinator?.moveTo(appFlow: TabBarFlow.auth(.login), userData: nil)
                    }
                    return cell
                } else { // MARK: - 로그인 유저
                    guard let cell = collectionView.dequeueReusableCell(MainNoPreferenceCell.self, indexPath: indexPath) else { return .init() }
                    cell.bind(nickName: viewModel.getUserInfoValue().nickname,
                              preference: StaticValues.getDrinkPairingById(viewModel.getUserInfoValue().preference.alcohols[0])?.name ?? "취향 선택 x")
                    cell.registerButton.setOpaqueTapGestureRecognizer { [weak self] in
                        self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.selectPhoto), userData: nil)
                    }
                    return cell
                }
            } else {
                guard let cell = collectionView.dequeueReusableCell(MainPreferenceCell.self, indexPath: indexPath) else { return .init() }
                cell.alcoholBind(viewModel.getSelectedAlcoholFeedsValue())
                return cell
            }
        case 1: // MARK: - 좋아요 많은 조합
            guard let cell = collectionView.dequeueReusableCell(MainLikeCell.self, indexPath: indexPath) else { return .init() }
            let popularFeed = viewModel.getPopularFeedsValue()[indexPath.item]
            cell.bind(popularFeed)
            
//            cell.containerView.setOpaqueTapGestureRecognizer { [weak self] in
//                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.detailFeed), userData: ["feedId": popularFeed.)
//            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(MainDifferenceCell.self, indexPath: indexPath) else { return .init() }
            let differenceFeed = viewModel.getDifferenceFeedsValue()[indexPath.item]
            cell.bind(differenceFeed)
            cell.containerView.setOpaqueTapGestureRecognizer { [weak self] in
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.detailFeed), userData: ["feedId": differenceFeed.feeds[0].feedId])
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let preferenceHeaderView = collectionView.dequeueSupplimentaryView(MainPreferenceHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath) else {
                return .init()
            }
            preferenceHeaderView.updateUI()
            if preferenceHeaderView.viewModel == nil {
                preferenceHeaderView.viewModel = self.viewModel
            }
            return preferenceHeaderView
        } else if indexPath.section == 1 {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let likeHeaderView = collectionView.dequeueSupplimentaryView(MainLikeHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath) else { return .init() }
                likeHeaderView.updateView(title: "좋아요 많은 조합", subTitle: "자주, 늘 먹는데에는 이유가 있는 법!", separator: true)
                return likeHeaderView
            }
        } else if indexPath.section == 2 {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let likeHeaderView = collectionView.dequeueSupplimentaryView(MainLikeHeaderView.self, supplementaryViewOfKind: .header, indexPath: indexPath) else { return .init() }
                likeHeaderView.updateView(title: "색다른 조합",
                                          subTitle: "맨날 먹던거만 먹으면 질리니까!!\n새로 만나는 우리, 제법 잘...어울릴지도??",
                                          separator: true)
                return likeHeaderView
            }
        }
        return UICollectionReusableView()
    }
}
