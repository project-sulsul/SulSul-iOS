//
//  RamdomFeedViewController.swift
//  Feature
//
//  Created by 김유진 on 3/7/24.
//

import UIKit
import Combine
import DesignSystem
import Service

public final class RamdomFeedViewController: BaseViewController, TransferHistoryBaseCoordinated {
    var coordinator: TransferHistoryBaseCoordinator?
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var viewModel = RandomFeedViewModel()
   
    private lazy var feedTitleLabel = UILabel().then {
        $0.text = "피드"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 28)
    }
    
    private lazy var seeMyPostLabel = UILabel().then {
        $0.text = "내 글보기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.semiBold(size: 14)
    }
    
    private lazy var feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.registerCell(RamdomFeedCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.contentInsetAdjustmentBehavior = .never
        $0.bounces = false
        
        $0.isPagingEnabled = true
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - tabBarHeight)
        }
        $0.collectionViewLayout = flowLayout
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        seeMyPostLabel.onTapped { [weak self] in
            // TODO: 마이페이지 이동
        }
    }
    
    private func bind() {
        viewModel.reloadData()
            .sink { [weak self] in
                self?.feedCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
    
    public override func addViews() {
        super.addViews()
        
        view.addSubviews([
            feedCollectionView,
            feedTitleLabel,
            seeMyPostLabel
        ])
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        feedCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        feedTitleLabel.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        seeMyPostLabel.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
    }
}

extension RamdomFeedViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.randomFeeds.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(RamdomFeedCell.self, indexPath: indexPath) else { return UICollectionViewCell() }
        
        cell.bind(viewModel.randomFeeds[indexPath.row])
        
        cell.seeAllLabel.onTapped { [weak self] in
            // TODO: 피드 상세 이동
        }
        
        cell.spamView.onTapped { [weak self] in
            // TODO: 신고 이동
        }
        
        cell.heartView.onTapped { [weak self] in
            if UserDefaultsUtil.shared.isLogin() {
                
                
            } else {
                self?.showToastMessageView(toastType: .error, title: "로그인이 필요한 서비스입니다.")
            }
        }
        
        return cell
    }
}
