//
//  RankingMainViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import Combine
import UIKit
import DesignSystem

public final class RankingMainViewController: BaseViewController, RankingBaseCoordinated {
    // MARK: - Properties
    //
    var coordinator: RankingBaseCoordinator?
    var viewModel: RankingMainViewModel
    
    private var viewControllers: [UIViewController] = []
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var rankingDrinkViewController = RankingDrinkViewController()
    
    private lazy var rankingCombinationViewController = RankingCombinationViewController()
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var topHeaderView = UIView()
    
    private lazy var logoImageView = LogoImageView()
    
    private lazy var searchTouchableImageView = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "common_search")
        $0.tintColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "이번 주 랭킹"
        $0.setLineHeight(38, font: Font.bold(size: 28))
        $0.font = Font.bold(size: 28)
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var weekendLabel = UILabel().then {
        $0.setLineHeight(22, font: Font.regular(size: 14))
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray600.color
        $0.alpha = 0
    }
    
    private lazy var pageTabBarContainerView = UIView()
    
    private lazy var horizontalFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var pageTabBarView = UICollectionView(frame: .zero, collectionViewLayout: horizontalFlowLayout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(PageTabBarCell.self, forCellWithReuseIdentifier: PageTabBarCell.reuseIdentifier)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        self.makeConstraints()
        self.preparePageViewController()
        self.bind()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.3) {
            self.weekendLabel.alpha = 1
        }
    }
    
    public override func addViews() {
        self.pageTabBarContainerView.addSubview(self.pageTabBarView)
        
        self.topHeaderView.addSubviews([
            self.logoImageView,
            self.searchTouchableImageView
        ])
        
        self.view.addSubviews([
            self.topHeaderView,
            self.titleLabel,
            self.weekendLabel,
            self.pageTabBarContainerView,
            self.pageViewController.view
        ])
        
        self.addChild(self.pageViewController)
    }
    
    public override func makeConstraints() {
        self.topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        self.searchTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        self.logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.width.equalTo(moderateScale(number: 96))
            $0.height.equalTo(moderateScale(number: 14))
        }
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.top.equalTo(self.topHeaderView.snp.bottom)
        }
        self.weekendLabel.snp.makeConstraints {
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.bottom.equalTo(self.titleLabel)
        }
        self.pageTabBarContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.height.equalTo(moderateScale(number: 40))
        }
        self.pageTabBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.bottom.equalToSuperview()
        }
        self.pageViewController.view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(self.pageTabBarView.snp.bottom).offset(moderateScale(number: 16))
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public override func setupIfNeeded() {
        self.searchTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.search), userData: nil)
        }
    }
    
    // MARK: - Initializer
    //
    init(viewModel: RankingMainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method
//
extension RankingMainViewController {
    private func bind() {
        self.viewModel.requestRankingDate()
        
        self.viewModel
            .rankingDatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                self.weekendLabel.text = "\(value.startDate) ~ \(value.endDate)"
            }
            .store(in: &cancelBag)
    }
    
    private func preparePageViewController() {
        self.viewControllers = [self.rankingDrinkViewController, self.rankingCombinationViewController]
        
        self.pageViewController.didMove(toParent: self)
        self.pageViewController.setViewControllers([self.viewControllers.first!], direction: .forward, animated: true)
    }
}

// MARK: - PageTabBar CollectionView DataSource
//
extension RankingMainViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.viewControllers.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTabBarCell.reuseIdentifier, for: indexPath) as? PageTabBarCell
        else { return .init() }
        
        if indexPath.item == 0 {
            cell.title = "술"
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else if indexPath.item == 1 {
            cell.title = "술+안주"
        }
        
        return cell
    }
}

// MARK: - PageTabBar CollectionView Delegate
//
extension RankingMainViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedViewController = viewControllers[indexPath.item]
        let direction: UIPageViewController.NavigationDirection = indexPath.item > 0 ? .forward : .reverse
        
        pageViewController.setViewControllers([selectedViewController], direction: direction, animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let itemWidth = scrollView.bounds.width / CGFloat(2)
        
        let selectedItem = Int((contentOffsetX + itemWidth / 2) / itemWidth)
        
        if selectedItem >= 0 && selectedItem < 2 {
            let indexPath = IndexPath(item: selectedItem, section: 0)
            pageTabBarView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - 페이지 탭바 CollectionViewFlowLayout 델리게이트
//
extension RankingMainViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth = collectionView.bounds.width / CGFloat(2)
        let itemHeight = moderateScale(number: 40)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - UIPageViewController DataSource
//
extension RankingMainViewController: UIPageViewControllerDataSource {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        
        return viewControllers[previousIndex]
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = currentIndex + 1
        guard nextIndex < viewControllers.count else { return nil }
        
        return viewControllers[nextIndex]
    }
}

// MARK: - UIPageViewController Delegate
//
extension RankingMainViewController: UIPageViewControllerDelegate {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = viewControllers.firstIndex(of: currentViewController) else { return }
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        pageTabBarView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView(pageTabBarView, didSelectItemAt: indexPath)
    }
}
