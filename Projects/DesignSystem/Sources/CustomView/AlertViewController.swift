//
//  AlertViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 2024/05/09.
//

import UIKit

public enum AlertType {
    case oneButton
    case twoButton
    case verticalTwoButton
}

final class AlertViewController: UIViewController {
    
    private lazy var backgroundView = UIView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
    }
    
    lazy var submitTouchableLabel = DefaultButton(title: "확인", alwaysClickable: true)
    
    private lazy var cancelTouchableLabel = DefaultButton(title: "취소", alwaysClickable: true)
    
    private lazy var titleStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 12)
        $0.axis = .vertical
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: moderateScale(number: 24),
                                 left: moderateScale(number: 24),
                                 bottom: moderateScale(number: 24),
                                 right: moderateScale(number: 24))
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = Font.regular(size: 16)
        $0.setLineHeight(moderateScale(number: 24), font: Font.regular(size: 16))
    }
    
    private let alertType: AlertType
    
    init(alertType: AlertType) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        view.addSubviews([backgroundView, containerView])
        containerView.addSubviews([titleStackView, cancelTouchableLabel, submitTouchableLabel])
        titleStackView.addArrangedSubviews([titleLabel, descriptionLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 30))
            $0.center.equalToSuperview()
        }
        
        switch alertType {
        case .oneButton:
            submitTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom)
                $0.height.equalTo(moderateScale(number: 52))
                $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 24))
            }
        case .twoButton:
            cancelTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom)
                $0.leading.bottom.equalToSuperview().inset(moderateScale(number: 24))
                $0.height.equalTo(moderateScale(number: 52))
                $0.trailing.equalTo(containerView.snp.centerX).offset(moderateScale(number: -8))
            }
            
            submitTouchableLabel.snp.makeConstraints {
                $0.top.height.equalTo(cancelTouchableLabel)
                $0.leading.equalTo(cancelTouchableLabel.snp.trailing).offset(moderateScale(number: 8))
                $0.trailing.bottom.equalToSuperview().inset(moderateScale(number: 24))
            }
            submitTouchableLabel.title("로그아웃")
            submitTouchableLabel.textColor(DesignSystemAsset.white.color)
            submitTouchableLabel.backgroundColor = DesignSystemAsset.red050.color
        case .verticalTwoButton:
            cancelTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom)
                $0.height.equalTo(moderateScale(number: 48))
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
                $0.centerX.equalToSuperview()
            }
            
            submitTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(cancelTouchableLabel.snp.bottom).offset(moderateScale(number: 8))
                $0.height.width.equalTo(cancelTouchableLabel)
                $0.bottom.equalToSuperview().inset(moderateScale(number: 16))
                $0.centerX.equalToSuperview()
            }
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
    func bind(title: String,
              description: String?,
              cancelText: String?,
              submitText: String?,
              submitCompletion: (() -> Void)?,
              cancelCompletion: (() -> Void)?) {
        
        submitTouchableLabel.onTapped { [weak self] in
            self?.dismiss(animated: false)
            submitCompletion?()
        }
        
        cancelTouchableLabel.onTapped { [weak self] in
            self?.dismiss(animated: false)
            cancelCompletion?()
        }
        
        titleLabel.text = title
        
        if let subTitle = description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = subTitle
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let cancelText = cancelText {
            cancelTouchableLabel.title(cancelText)
        }
        
        if let submitText = submitText {
            submitTouchableLabel.title(submitText)
        }
    }
}
