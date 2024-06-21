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
    var delegate: MyFeedViewDelegate?
    var coordinator: MoreBaseCoordinator?
    private let viewModel: ProfileMainViewModel
    
    private lazy var topHeaderView = UIView()
    
    private lazy var logoImageView = LogoImageView()
    
    private lazy var settingTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_setting")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    private lazy var containerView = UIView()
    
    private lazy var profileView = UIView()
    
    private lazy var profileLabelStackView = UIStackView().then({
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 8)
    })
    
    private lazy var profileLabel = UILabel().then({
        $0.font = Font.bold(size: 32)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var profileEditTouchableLabel = TouchableLabel().then({
        $0.text = "프로필 수정"
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray300.color
    })
    
    private lazy var profileTouchableImageView = UIImageView().then({
        $0.image = UIImage(named: "profile_notUser")
        $0.contentMode = .scaleAspectFit
    })
    
    private lazy var selectFeedView = UIStackView().then({
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    })
    
    private lazy var myFeedTouchableView = UnderlineTouchableView("나의 피드").then({
        $0.updateView(true)
    })
    
    private lazy var likeFeedTouchableView = UnderlineTouchableView("좋아요 표시한 피드").then({
        $0.updateView(false)
    })
    
    private lazy var myFeedView = MyFeedView(viewModel: viewModel, tabBarController: self.tabBarController ?? UITabBarController()).then({
        $0.delegate = self
    })
    
    private lazy var likeFeedView = LikeFeedView( viewModel: viewModel, tabBarController: self.tabBarController ?? UITabBarController()).then({
        $0.isHidden = true
    })
    
    init(viewModel: ProfileMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        makeConstraints()
        bind()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        viewModel.getUserInfo()
    }
    
    private func bind() {
        viewModel.userInfoPublisher()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                if result.status == UserInfoStatus.notLogin.rawValue { // MARK: - 로그인 하지 않은 유저
                    self.profileLabel.text = "로그인 해주세요!"
                    self.profileEditTouchableLabel.isHidden = true
                    self.myFeedView.updateState(.notLogin)
                    self.likeFeedView.updateState(.notLogin)
                } else if result.status == UserInfoStatus.banned.rawValue { // MARK: - 밴된 유저
                    // MARK: - 밴된 유저
                } else { // MARK: - 로그인한 유저
                    self.profileLabel.text = result.nickname
                    self.profileEditTouchableLabel.isHidden = false
                    if let imageURL = URL(string: result.image ?? "") {
                        self.profileTouchableImageView.kf.setImage(with: imageURL)
                    }
                    viewModel.getFeedsByMe()
                    viewModel.getFeedsLikeByMe()
                }
            }.store(in: &cancelBag)
        
        viewModel.loginButtonIsTappedPublisher()
              .receive(on: DispatchQueue.main)
              .sink { [weak self] _ in
                self?.coordinator?.moveTo(appFlow: TabBarFlow.auth(.login), userData: nil)
              }.store(in: &cancelBag)    
        
        viewModel.goFeedButtonIsTappedPublisher()
              .receive(on: DispatchQueue.main)
              .sink { [weak self] _ in
                  self?.coordinator?.moveTo(appFlow: TabBarFlow.home(.main), userData: nil)
              }.store(in: &cancelBag)
        
        viewModel.detailFeedPublisher()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.detailFeed), userData: ["feedId": response])
            }.store(in: &cancelBag)
        
        StaticValues.isLoggedInPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginStatus in
                guard let self = self else { return }
                viewModel.getUserInfo()
            }.store(in: &cancelBag)
    
    }
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          containerView])
        topHeaderView.addSubviews([
            logoImageView,
            settingTouchableImageView
        ])
        containerView.addSubviews([profileView,
                                   selectFeedView,
                                   myFeedView,
                                   likeFeedView])
        profileView.addSubviews([profileLabelStackView,
                                 profileTouchableImageView])
        profileLabelStackView.addArrangedSubviews([profileLabel,
                                                   profileEditTouchableLabel])
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
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.width.equalTo(moderateScale(number: 96))
            $0.height.equalTo(moderateScale(number: 14))
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
        profileLabelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
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
            $0.leading.equalToSuperview().offset(moderateScale(number: -10))
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    public override func setupIfNeeded() {
        myFeedTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            myFeedTouchableView.updateView(true)
            likeFeedTouchableView.updateView(false)
            self.likeFeedView.isHidden = true
            self.myFeedView.isHidden = false
        }
        likeFeedTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            myFeedTouchableView.updateView(false)
            likeFeedTouchableView.updateView(true)
            self.myFeedView.isHidden = true
            self.likeFeedView.isHidden = false
        }
        
        settingTouchableImageView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.more(.profileSetting), userData: nil)
        }
        
        profileEditTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.coordinator?.moveTo(appFlow: TabBarFlow.more(.profileEdit), userData: ["delegate": self])
        }
    }
    
    @objc func profileIsChanged() {
        viewModel.getUserInfo()
    }
}

// MARK: - MyFeedView Delegate
//
extension ProfileMainViewController: MyFeedViewDelegate {
    func didTapNextLabel() {
        self.coordinator?.moveTo(appFlow: TabBarFlow.more(.writeFeed), userData: nil)
    }
}
