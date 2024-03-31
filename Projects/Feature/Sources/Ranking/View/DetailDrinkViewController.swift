//
//  DrinkDetailViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-18.
//

import Combine
import UIKit
import DesignSystem

final class DetailDrinkViewController: BaseViewController {
    var coordinator: RankingBaseCoordinator?
    // MARK: - Custom Property
    private var cancelBag = Set<AnyCancellable>()
    private var viewControllers: [UIViewController] = []
    
    private let descriptionOfList = ["종류", "도수", "원산지"]
    private let dummyOfList = ["희석식 소주", "16%", "한국"]
    
    private lazy var recommendSnackViewController = RecommendSnackViewController()
    private lazy var relatedFeedViewController = RelatedFeedViewController()
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var baseTopView = BaseTopView().then {
        $0.frame = .zero
    }
    
    private lazy var rightBarButton = TouchableLabel().then {
        $0.setLineHeight(22, font: Font.semiBold(size: 14))
        $0.font = Font.semiBold(size: 14)
        $0.text = "취향에 추가"
        $0.textColor = DesignSystemAsset.main.color
    }
    
    private lazy var parentTitleLabel = UILabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.text = "이번주 랭킹"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkContainerView = UIView().then {
        $0.frame = .zero
    }
    
    private lazy var pageTabBarContainerView = UIView().then {
        $0.frame = .zero
    }
    
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
    
    private lazy var drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "circle.fill")
        $0.backgroundColor = .red
    }
    
    private lazy var medalImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "circle.fill")
        $0.backgroundColor = DesignSystemAsset.main.color
    }
    
    private lazy var drinkNameLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.bold(size: 28))
        $0.font = Font.bold(size: 28)
        $0.text = "참이슬 후레쉬"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = CGFloat(8)
        $0.distribution = .fillEqually
    }
    
    private lazy var descriptionValueStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = CGFloat(8)
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.setTabBarHidden(true)
        
        prepareStackViews()
        addViews()
        makeConstraints()
        configurePageViewController()
    }
    
    public override func addViews() {
        baseTopView.addSubviews([
            parentTitleLabel,
            rightBarButton
        ])
        
        drinkContainerView.addSubviews([
            drinkImageView,
            medalImageView,
            drinkNameLabel,
            descriptionStackView,
            descriptionValueStackView
        ])
        
        pageTabBarContainerView.addSubview(pageTabBarView)
        
        view.addSubviews([
            baseTopView,
            drinkContainerView,
            pageTabBarContainerView,
            pageViewController.view
        ])
        
        addChild(pageViewController)
    }
    
    public override func makeConstraints() {
        baseTopView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        parentTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(baseTopView.backTouchableView.snp.trailing)
            $0.trailing.equalTo(rightBarButton.snp.leading)
            $0.top.bottom.equalTo(baseTopView.backTouchableView)
        }
        rightBarButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.bottom.equalTo(baseTopView.backTouchableView)
        }
        drinkContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(baseTopView.snp.bottom)
            $0.height.equalTo(moderateScale(number: 160))
        }
        drinkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.bottom.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 160))
        }
        medalImageView.snp.makeConstraints {
            $0.leading.equalTo(drinkImageView.snp.trailing)
            $0.top.equalTo(drinkImageView)
            $0.size.equalTo(moderateScale(number: 24))
        }
        drinkNameLabel.snp.makeConstraints {
            $0.leading.equalTo(medalImageView)
            $0.top.equalTo(medalImageView.snp.bottom)
        }
        descriptionStackView.snp.makeConstraints {
            $0.leading.equalTo(medalImageView)
            $0.top.equalTo(drinkNameLabel.snp.bottom)
            $0.bottom.equalTo(drinkContainerView.snp.bottom).inset(moderateScale(number: 8))
        }
        descriptionValueStackView.snp.makeConstraints {
            $0.leading.equalTo(descriptionStackView.snp.trailing).offset(moderateScale(number: 8))
            $0.top.bottom.equalTo(descriptionStackView)
        }
        pageTabBarContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(drinkContainerView.snp.bottom).offset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 40))
        }
        pageTabBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.bottom.equalToSuperview()
        }
        pageViewController.view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(pageTabBarView.snp.bottom).offset(moderateScale(number: 16))
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Custom Method
    
    private func configurePageViewController() {
        viewControllers = [recommendSnackViewController, relatedFeedViewController]
        
        pageViewController.didMove(toParent: self)
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: true)
    }
    
    private func createDescriptionLabel(_ value: String) -> UILabel {
        let label = UILabel().then {
            $0.setLineHeight(22, font: Font.semiBold(size: 14))
            $0.font = Font.semiBold(size: 14)
            $0.textColor = DesignSystemAsset.gray500.color
            $0.text = value
        }
        
        return label
    }
    
    private func createDescriptionValueLabel(_ value: String) -> UILabel {
        let label = PaddableLabel(edgeInsets: 2, 8, 2, 8).then {
            $0.setLineHeight(16, font: Font.regular(size: 10))
            $0.font = Font.regular(size: 10)
            $0.textColor = DesignSystemAsset.gray900.color
            $0.backgroundColor = DesignSystemAsset.gray200.color
            $0.layer.cornerRadius = CGFloat(8)
            $0.layer.masksToBounds = true
            $0.text = value
        }
        
        return label
    }
    
    private func prepareStackViews() {
        for (index, item) in descriptionOfList.enumerated() {
            let descriptionLabel = createDescriptionLabel(item)
            let descriptionValueLabel = createDescriptionValueLabel(dummyOfList[index])
            
            descriptionStackView.addArrangedSubview(descriptionLabel)
            descriptionValueStackView.addArrangedSubview(descriptionValueLabel)
        }
    }
}

// MARK: - PageTabBar CollectionView DataSource
extension DetailDrinkViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTabBarCell.reuseIdentifier, for: indexPath)
                as? PageTabBarCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.title = "안주 추천"
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else if indexPath.item == 1 {
            cell.title = "포함피드"
        }
        
        return cell
    }
}

// MARK: - PageTabBar CollectionView Delegate

extension DetailDrinkViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedViewController = viewControllers[indexPath.item]
        let direction: UIPageViewController.NavigationDirection = indexPath.item > 0 ? .forward : .reverse
        
        pageViewController.setViewControllers([selectedViewController], direction: direction, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let itemWidth = scrollView.bounds.width / CGFloat(2)
        
        let selectedItem = Int((contentOffsetX + itemWidth / 2) / itemWidth)
        
        if selectedItem >= 0 && selectedItem < 2 {
            let indexPath = IndexPath(item: selectedItem, section: 0)
            pageTabBarView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - PageTabBar CollectionViewFlowLayout Delegate

extension DetailDrinkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth = collectionView.bounds.width / CGFloat(2)
        let itemHeight = moderateScale(number: 40)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - UIPageViewController DataSource

extension DetailDrinkViewController: UIPageViewControllerDataSource {
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

extension DetailDrinkViewController: UIPageViewControllerDelegate {
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
    
    private func updateTabIndex() {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = viewControllers.firstIndex(of: currentViewController) else { return }
    }
}
