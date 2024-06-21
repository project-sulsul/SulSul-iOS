//
//  AuthViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import DesignSystem
import GoogleSignIn
import UIKit
import Combine

public final class AuthViewController: HiddenTabBarBaseViewController {
    var viewModel: AuthViewModel?
    var coordinator: AuthBaseCoordinator?
    private var cancelBag = Set<AnyCancellable>()

    private lazy var topView = UIView().then {
        $0.frame = .zero
    }

    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(40, text: "만나서\n반가워요! :)", font: Font.bold(size: 32))
        $0.numberOfLines = 2
        $0.textColor = DesignSystemAsset.gray900.color
    }

    private lazy var kakaoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_kakao")
    }

    private lazy var googleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_google")
    }

    private lazy var appleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_apple")
    }

    private lazy var continueWithKakao = TouchableView().then {
        $0.addSubview(kakaoImage)
    }

    private lazy var continueWithGoogle = TouchableView().then {
        $0.addSubview(googleImage)
    }

    private lazy var continueWithApple = TouchableView().then {
        $0.addSubview(appleImage)
    }
    
    private lazy var backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        $0.setImage(UIImage(named: "left_arrow"), for: .normal)
    }
    
    private lazy var termsButton = UIButton().then {
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.numberOfLines = 2
        $0.titleLabel?.font = Font.medium(size: 14)
        
        let attributedText = NSMutableAttributedString(string: "가입을 진행할 경우, 서비스 약관 및\n개인정보 처리방침에 동의한 것으로 간주합니다.")

        attributedText.addAttribute(.font, value: Font.bold(size: 14), range: NSRange(location: 12, length: 6))
        attributedText.addAttribute(.foregroundColor, value: DesignSystemAsset.gray800.color, range: NSRange(location: 12, length: 6))
        
        attributedText.addAttribute(.font, value: Font.bold(size: 14), range: NSRange(location: 21, length: 9))
        attributedText.addAttribute(.foregroundColor, value: DesignSystemAsset.gray800.color, range: NSRange(location: 21, length: 9))
        
        let otherTextRange = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.foregroundColor, value: DesignSystemAsset.gray500.color, range: otherTextRange)
        
        $0.setAttributedTitle(attributedText, for: .normal)
        $0.addTarget(self, action: #selector(termsButtonDidTap), for: .touchUpInside)
    }
    
    override public func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        viewModel = AuthViewModel()
        
        addViews()
        makeConstraints()
        setupIfNeeded()
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.userSettingTypePublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .initSettingUser:
                    coordinator?.moveTo(appFlow: TabBarFlow.auth(.profileInput(.setUserName)), userData: nil)
                case .nickNameSettingUser:
                    coordinator?.moveTo(appFlow: TabBarFlow.auth(.profileInput(.selectDrink)), userData: nil)
                case .drinkSettingUser:
                    coordinator?.moveTo(appFlow: TabBarFlow.auth(.profileInput(.selectSnack)), userData: nil)
                case .allSettingUSer:
                    StaticValues.isLoggedIn.send(true)
                    self.navigationController?.popViewController(animated: true)
                }
            }.store(in: &cancelBag)
        
        viewModel.getErrorSubject()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard self?.topViewController() is Self else { return }
                self?.showAlertView(withType: .oneButton,
                                    title: error,
                                    description: error,
                                    submitCompletion: nil,
                                    cancelCompletion: nil)
            }.store(in: &cancelBag)
    }

    override public func addViews() {
        view.addSubviews([
            topView,
            continueWithKakao,
            continueWithGoogle,
            continueWithApple,
            termsButton
        ])
        topView.addSubviews([
            backButton,
            titleLabel
        ])
    }

    override public func makeConstraints() {
        topView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(152)
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 24))
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton)
            $0.top.equalTo(backButton.snp.bottom).offset(moderateScale(number: 16))
        }
        continueWithKakao.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(moderateScale(number: 239))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(48)
        }
        kakaoImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        continueWithGoogle.snp.makeConstraints {
            $0.top.equalTo(continueWithKakao.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalTo(continueWithKakao)
            $0.width.height.equalTo(continueWithKakao)
        }
        googleImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        continueWithApple.snp.makeConstraints {
            $0.top.equalTo(continueWithGoogle.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalTo(continueWithGoogle)
            $0.width.height.equalTo(continueWithKakao)
        }
        appleImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        termsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(moderateScale(number: -8))
        }
    }

    override public func setupIfNeeded() {
        continueWithKakao.setOpaqueTapGestureRecognizer { [weak self] in
            self?.viewModel?.continueWithKakao()
        }
        
        continueWithGoogle.setOpaqueTapGestureRecognizer { [weak self] in
            let id = "78471557734-vab1c2tk22mhkal1gg5v32p97qb1a0ra.apps.googleusercontent.com"
            let configuration = GIDConfiguration(clientID: id)
            GIDSignIn.sharedInstance.configuration = configuration
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self!) { [weak self] signInResult, _ in
                guard let self,
                      let result = signInResult,
                      let token = result.user.idToken?.tokenString else { return }
                self.viewModel?.continueWithGoogle(id: id, item: token)
            }
            
        }
        
        continueWithApple.setOpaqueTapGestureRecognizer { [weak self] in
            self?.viewModel?.continueWithApple()
        }
    }

}

// MARK: - @objc

extension AuthViewController {
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func termsButtonDidTap() {
        #warning("서비스 약관, 개인정보 처리방침 뷰어로 이동해야 해요.")
    }
}
