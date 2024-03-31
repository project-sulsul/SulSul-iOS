//
//  SetUserNameViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import Combine
import UIKit
import DesignSystem

public final class SetUserNameViewController: BaseViewController {
    
    private var viewModel: SelectUserNameViewModel?
    private var cancelBag = Set<AnyCancellable>()
    private var randomNickname = ""
    
    private lazy var topHeaderView = UIView()
    
    private lazy var defaultStackView = ValidationLabelStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
    }
    
    private lazy var specialCharactersStackView = ValidationLabelStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.isHidden = true
    }
    
    private lazy var lessThanCharactersStackView = ValidationLabelStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.isHidden = true
    }
    
    private lazy var induceUserNameLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.text = "어떤 닉네임을 사용할까요?"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var userNameTextField = UITextField().then {
        $0.rightView = clearButton
        $0.rightViewMode = .always
        $0.delegate = self
        $0.font = Font.bold(size: 32)
        $0.tintColor = DesignSystemAsset.white.color
        $0.placeholder = "닉네임을 입력해주세요."
    }
    
    private lazy var backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        $0.setImage(UIImage(named: "left_arrow"), for: .normal)
    }
    
    private lazy var clearButton = UIButton().then {
        $0.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        $0.setImage(UIImage(named: "filled_clear"), for: .normal)
    }
    
    private lazy var generateButton = UIButton().then {
        $0.addTarget(self, action: #selector(generateButtonDidTap), for: .touchUpInside)
        $0.backgroundColor = DesignSystemAsset.gray300.color
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.titleLabel?.textColor = DesignSystemAsset.gray700.color
        $0.layer.cornerRadius = CGFloat(8)
        $0.setTitle("다른거 할래요", for: .normal)
    }
    
    private lazy var resetButton = UIButton().then {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = Font.bold(size: 16)
        
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .clear
        configuration.attributedTitle = AttributedString("랜덤 닉네임 쓸래요!", attributes: attributeContainer)
        
        $0.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
        $0.configuration = configuration
        $0.contentMode = .center
        $0.isHidden = true
        $0.tintColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        $0.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.layer.cornerRadius = CGFloat(12)
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(DesignSystemAsset.gray200.color, for: .normal)
        $0.isEnabled = true
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        viewModel = SelectUserNameViewModel()
        viewModel?.requestRandomNickname()
        
        bind()
        addViews()
        makeConstraints()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    public override func addViews() {
        topHeaderView.addSubviews([backButton, induceUserNameLabel])
        view.addSubviews([topHeaderView, userNameTextField, defaultStackView, specialCharactersStackView,
                          lessThanCharactersStackView, generateButton, resetButton, nextButton])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 59))
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        induceUserNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(backButton.snp.bottom).offset(moderateScale(number: 16))
        }
        userNameTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(topHeaderView)
            $0.top.equalTo(topHeaderView.snp.bottom).offset(moderateScale(number: 28))
        }
        defaultStackView.snp.makeConstraints {
            $0.leading.equalTo(userNameTextField)
            $0.top.equalTo(userNameTextField.snp.bottom).offset(8)
        }
        specialCharactersStackView.snp.makeConstraints {
            $0.leading.equalTo(userNameTextField)
            $0.top.equalTo(userNameTextField.snp.bottom).offset(8)
        }
        lessThanCharactersStackView.snp.makeConstraints {
            $0.leading.equalTo(specialCharactersStackView)
            $0.top.equalTo(specialCharactersStackView.snp.bottom).offset(8)
        }
        generateButton.snp.makeConstraints {
            $0.trailing.equalTo(userNameTextField)
            $0.top.equalTo(defaultStackView.snp.bottom).offset(16)
            $0.width.equalTo(moderateScale(number: 135))
            $0.height.equalTo(moderateScale(number: 40))
        }
        resetButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
            $0.width.equalTo(171)
            $0.height.equalTo(32)
            $0.centerX.equalTo(nextButton)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(topHeaderView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 50))
        }
    }
    
    public override func deinitialize() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SetUserNameViewController: UITextFieldDelegate {
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateValidationLabelStackView(text: textField.text)
        return true
    }
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        let canonicalText = newText.precomposedStringWithCanonicalMapping
        print(canonicalText)
        updateValidationLabelStackView(text: newText)
        return true
    }
}

// MARK: - Custom method

extension SetUserNameViewController {
    private func bind() {
        viewModel?.userNamePublisher()
            .sink { [weak self] userName in
                self?.userNameTextField.text = userName
                self?.randomNickname = userName
            }
            .store(in: &cancelBag)
    }
    
    private func updateValidationLabelStackView(text: String?) {
        guard let userName = text else { return }
        let containsSpecialCharacters = userName.range(of: "[^a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ0-9\\s]", options: .regularExpression) != nil
        let hasValidLength = (1...10).contains(userName.count)

        if userName == randomNickname {
            configureStackViewsForDefaultState()
        }
        
        if userName.isEmpty {
            configureStackViewsForCommonState()
            updateNextButton(false)
        } else {
            if !containsSpecialCharacters, hasValidLength {
                configureStackViewsForPassState(containsSpecialCharacters: false, hasValidLength: true)
                updateNextButton(true)
            } else if containsSpecialCharacters, hasValidLength {
                configureStackViewsForPassState(containsSpecialCharacters: true, hasValidLength: true)
                updateNextButton(false)
            } else if !containsSpecialCharacters, !hasValidLength {
                configureStackViewsForPassState(containsSpecialCharacters: false, hasValidLength: false)
                updateNextButton(false)
            } else {
                configureStackViewsForPassState(containsSpecialCharacters: true, hasValidLength: false)
                updateNextButton(false)
            }
        }
    }
    
    private func updateNextButton(_ enable: Bool) {
        let yellowColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
        nextButton.backgroundColor = enable ? yellowColor : DesignSystemAsset.gray300.color
        nextButton.isEnabled = enable
    }
    
    private func configureStackViewsForDefaultState() {
        defaultStackView.isHidden = false
        specialCharactersStackView.isHidden = true
        lessThanCharactersStackView.isHidden = true
        generateButton.isHidden = false
        resetButton.isHidden = true
    }
    
    private func configureStackViewsForCommonState() {
        specialCharactersStackView.configure(to: .common, "특수문자 사용은 안돼요.")
        lessThanCharactersStackView.configure(to: .common, "한글/영문, 숫자 포함 10자로 사용 가능해요.")
        
        defaultStackView.isHidden = true
        specialCharactersStackView.isHidden = false
        lessThanCharactersStackView.isHidden = false
        generateButton.isHidden = true
        resetButton.isHidden = false
    }
    
    private func configureStackViewsForPassState(containsSpecialCharacters: Bool, hasValidLength: Bool) {
        specialCharactersStackView.configure(
            to: containsSpecialCharacters ? .nonpass : .pass,
            containsSpecialCharacters ? "특수문자가 포함되어 있어요." : "입력된 특수문자가 없어요."
        )
        lessThanCharactersStackView.configure(
            to: hasValidLength ? .pass : .nonpass,
            hasValidLength ? "적절한 글자수의 닉네임이에요." : "한글/영문, 숫자 포함 1~10자 이내로 설정해주세요."
        )
        
        defaultStackView.isHidden = true
        specialCharactersStackView.isHidden = false
        lessThanCharactersStackView.isHidden = false
        generateButton.isHidden = true
        resetButton.isHidden = false
    }
}

// MARK: - @objc

extension SetUserNameViewController {
    @objc private func backButtonDidTap() {}
    
    @objc private func clearButtonDidTap() {
        let emptyString = ""
        userNameTextField.text = emptyString
        updateValidationLabelStackView(text: emptyString)
    }
    
    @objc private func generateButtonDidTap() {
        viewModel?.requestRandomNickname()
    }
    
    @objc private func resetButtonDidTap() {
        userNameTextField.text = randomNickname
        configureStackViewsForDefaultState()
        updateNextButton(true)
    }
    
    @objc private func nextButtonDidTap() {
        #warning("다음 화면으로 이동하는 것을 구현해야 해요.")
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = view.convert(keyboardFrame, to: nil).size.height
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.nextButton.snp.remakeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(moderateScale(number: 50))
            }
            self?.nextButton.layer.cornerRadius = CGFloat(0)
            self?.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self?.resetButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.nextButton.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.bottom.equalTo(self?.view.safeAreaLayoutGuide ?? 0)
                $0.height.equalTo(moderateScale(number: 50))
            }
            self?.nextButton.layer.cornerRadius = CGFloat(12)
            self?.nextButton.transform = .identity
            self?.resetButton.transform = .identity
            self?.view.layoutIfNeeded()
        }
    }
}
