//
//  SettingViewController.swift
//  Feature
//
//  Created by 이범준 on 12/31/23.
//

import UIKit
import Then
import DesignSystem
import Service

public final class ProfileSettingViewController: BaseViewController {
    var coordinator: MoreBaseCoordinator?
    
    private lazy var topHeaderView = BaseTopView()
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    private lazy var titleLabel = UILabel().then({
        $0.text = "설정"
        $0.font = Font.bold(size: 32)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    private lazy var settingStackView = UIStackView().then({
        $0.axis = .vertical
        $0.distribution = .fillEqually
    })
    private lazy var managementTitleLabel = UILabel().then({
        $0.text = "취향 관리"
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray500.color
    })
    private lazy var drinkSettingView = SettingView(settingType: .arrow,
                                                    title: "술 설정")
    private lazy var snackSettingView = SettingView(settingType: .arrow,
                                                    title: "안주 설정")
    private lazy var appSettingTitleLabel = UILabel().then({
        $0.text = "앱 설정"
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray500.color
    })
    private lazy var alarmSettingView = SettingView(settingType: .toggle,
                                                    title: "알림")
    private lazy var feedBackSettingView = SettingView(settingType: .arrow,
                                                       title: "피드백")
    private lazy var termsSettingView = SettingView(settingType: .arrow,
                                                    title: "이용약관")
    private lazy var personalSettingView = SettingView(settingType: .arrow,
                                                       title: "개인정보 처리방침")
    private lazy var signOutSettingView = SettingView(settingType: .arrow,
                                                      title: "회원탈퇴")
    private lazy var logoutTouchaleLabel = TouchableLabel().then({
        $0.text = "로그아웃"
        $0.textColor = DesignSystemAsset.red050.color
        $0.font = Font.bold(size: 16)
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        super.addViews()
        view.addSubviews([topHeaderView,
                          scrollView])
        scrollView.addSubview(containerView)
        containerView.addSubviews([titleLabel,
                                   settingStackView,
                                   logoutTouchaleLabel])
        settingStackView.addArrangedSubviews([managementTitleLabel,
                                              drinkSettingView,
                                              snackSettingView,
                                              appSettingTitleLabel,
                                              alarmSettingView,
                                              feedBackSettingView,
                                              termsSettingView,
                                              personalSettingView,
                                              signOutSettingView])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        settingStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 378))
        }
        logoutTouchaleLabel.snp.makeConstraints {
            $0.top.equalTo(settingStackView.snp.bottom).offset(moderateScale(number: 67))
            $0.centerX.equalToSuperview()
        }
    }
    
    public override func setupIfNeeded() {
        topHeaderView.backTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        drinkSettingView.containerView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.coordinator?.moveTo(appFlow: TabBarFlow.more(.selectDrink), userData: nil)
        }
        snackSettingView.containerView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.coordinator?.moveTo(appFlow: TabBarFlow.more(.selectSnack), userData: nil)
        }
        signOutSettingView.containerView.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.setTabBarHidden(true)
            self.showBottomSheetAlertView(bottomSheetAlertType: .twoButton,
                                          title: "회원탈퇴",
                                          description: "지금 탈퇴를 진행하면 7일동안 재가입이 불가능하며,\n기존에 작성했던 모든 피드와 취향 정보가 삭제돼요.",
                                          submitCompletion: nil,
                                          cancelCompletion: {self.tabBarController?.setTabBarHidden(false)})
        }
        logoutTouchaleLabel.setOpaqueTapGestureRecognizer { [weak self] in
            self?.showAlertView(withType: .twoButton,
                                title: "로그아웃 하시겠어요?",
                                description: nil,
                                submitCompletion: {
                KeychainStore.shared.delete(label: "accessToken")
                UserDefaultsUtil.shared.remove(.userId)
            },
                                cancelCompletion: nil)
        }
    }
}
