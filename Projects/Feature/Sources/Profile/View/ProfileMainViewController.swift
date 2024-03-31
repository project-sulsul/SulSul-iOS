//
//  ProfileMainViewController.swift
//  Feature
//
//  Created by 이범준 on 2024/01/08.
//

import UIKit
import Then
import DesignSystem
import Combine
import Kingfisher

public final class ProfileMainViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    var coordinator: MoreBaseCoordinator?
    private let viewModel = ProfileMainViewModel()
    
    private lazy var topHeaderView = UIView()
    private lazy var searchTouchableIamgeView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_search")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    private lazy var settingTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_setting")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    private lazy var containerView = UIView()
    
    private lazy var profileView = UIView()
    
    private lazy var profileLabel = UILabel().then({
        $0.text = "testestese"
        $0.font = Font.bold(size: 32)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var profileEditTouchableLabel = TouchableLabel().then({
        $0.text = "프로필 수정"
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray300.color
    })
    
    private lazy var profileTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "profile_notUser")
    })
    
    private lazy var selectFeedView = UIStackView().then({
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    })
    
    private lazy var myFeedTouchableView = TouchableView().then({
        $0.backgroundColor = .red
    })
    
    private lazy var likeFeedTouchableView = TouchableView().then({
        $0.backgroundColor = .blue
    })
    
    private lazy var myFeedView = MyFeedView(viewModel: viewModel, tabBarController: self.tabBarController ?? UITabBarController())
    
    private lazy var likeFeedView = LikeFeedView( viewModel: viewModel, tabBarController: self.tabBarController ?? UITabBarController()).then({
        $0.isHidden = true
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        addViews()
        makeConstraints()
        bind()
    }
    
    private func bind() {
        viewModel.userInfoPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.profileLabel.text = result.nickname
                if let imageURL = URL(string: result.image ?? "") {
                    self?.profileTouchableImageView.kf.setImage(with: imageURL)
                }
            }.store(in: &cancelBag)
        
        viewModel.getUserInfo()
    }
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          containerView])
        topHeaderView.addSubviews([searchTouchableIamgeView,
                                   settingTouchableImageView])
        containerView.addSubviews([profileView,
                                   selectFeedView,
                                   myFeedView,
                                   likeFeedView])
        profileView.addSubviews([profileLabel,
                                 profileEditTouchableLabel,
                                 profileTouchableImageView])
        selectFeedView.addArrangedSubviews([myFeedTouchableView,
                                            likeFeedTouchableView])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        searchTouchableIamgeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(settingTouchableImageView.snp.leading).offset(moderateScale(number: -12))
            $0.size.equalTo(moderateScale(number: 24))
        }
        settingTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 72))
        }
        profileLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        profileEditTouchableLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
        profileTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 64))
        }
        selectFeedView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 40))
        }
        myFeedTouchableView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        likeFeedTouchableView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        myFeedView.snp.makeConstraints {
            $0.top.equalTo(selectFeedView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        likeFeedView.snp.makeConstraints {
            $0.top.equalTo(selectFeedView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public override func setupIfNeeded() {
        myFeedTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.likeFeedView.isHidden = true
            self.myFeedView.isHidden = false
        }
        likeFeedTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.myFeedView.isHidden = true
            self.likeFeedView.isHidden = false
        }
        settingTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.more(.profileSetting), userData: nil)
        }
        profileTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.more(.profileEdit), userData: nil)
        }
        profileEditTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.more(.profileEdit), userData: nil)
        }
    }
}
