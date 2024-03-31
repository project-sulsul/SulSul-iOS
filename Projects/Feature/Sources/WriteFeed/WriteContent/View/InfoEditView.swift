//
//  InfoEditView.swift
//  Feature
//
//  Created by 김유진 on 3/1/24.
//

import UIKit
import DesignSystem

final class InfoEditView: UIView {
    private lazy var initSnack: String? = nil
    private lazy var initDrink: String? = nil
    private lazy var containerView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 24)
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "인식된 술&안주 정보 수정"
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkLabel = UILabel().then {
        $0.text = "술"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkTextFieldView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.borderColor = DesignSystemAsset.gray100.color.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
    }
    
    private lazy var drinkTextField = UITextField().then {
        $0.placeholder = "술을 입력해주세요."
        $0.delegate = self
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.addTarget(self, action: #selector(handleTextFieldDidChange), for: .editingChanged)
    }
    
    private lazy var snackLabel = UILabel().then {
        $0.text = "안주"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
        
    }
    
    private lazy var snackTextFieldView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.borderColor = DesignSystemAsset.gray100.color.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
    }
    
    private lazy var snackTextField = UITextField().then {
        $0.placeholder = "안주를 입력해주세요."
        $0.font = Font.semiBold(size: 16)
        $0.delegate = self
        $0.textColor = DesignSystemAsset.gray900.color
        $0.addTarget(self, action: #selector(handleTextFieldDidChange), for: .editingChanged)
    }
    
    private lazy var completeButton = DefaultButton(title: "수정 완료!")
    
    init(delegate: OnSelectedValue) {
        super.init(frame: .zero)
        
        attributes()
        layout()
        
        completeButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            self?.isHidden = true
            
            if let snack = selfRef.snackTextField.text,
               let drink = selfRef.drinkTextField.text {
                
                delegate.selectedValue(["writtenText": [drink, snack]])
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ recognized: WriteContentModel.Recognized) {
        if let alchol = recognized.alcohols.first {
            initDrink = alchol
            drinkTextField.text = alchol
        }
        
        if let food = recognized.foods.first {
            initSnack = food
            snackTextField.text = food
        }
        
        completeButton.setClickable(false)
    }
    
    @objc private func handleTextFieldDidChange() {
        guard let snack = snackTextField.text, let drink = drinkTextField.text else { return }
        
        let isNotTextEmpty = (snack.removeSpace() != "") && (drink.removeSpace() != "")
        
        completeButton.setClickable(isNotTextEmpty)
    }
}

extension InfoEditView {
    private func attributes() {
        overrideUserInterfaceStyle = .dark
        backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func layout() {
        addSubview(containerView)
        
        containerView.addSubviews([
            titleLabel,
            drinkLabel,
            drinkTextFieldView,
            snackLabel,
            snackTextFieldView,
            completeButton
        ])
        
        drinkTextFieldView.addSubview(drinkTextField)
        snackTextFieldView.addSubview(snackTextField)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 353))
            $0.height.equalTo(moderateScale(number: 348))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        drinkLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 24))
        }
        
        drinkTextFieldView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(drinkLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        drinkTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
        
        snackLabel.snp.makeConstraints {
            $0.top.equalTo(drinkTextFieldView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalTo(drinkLabel)
        }
        
        snackTextFieldView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(snackLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        snackTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
        }
    }
}

extension InfoEditView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
}
