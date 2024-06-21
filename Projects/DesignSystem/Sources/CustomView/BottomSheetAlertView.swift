//
//  BottomSheetAlertView.swift
//  DesignSystem
//
//  Created by 이범준 on 1/13/24.
//

import UIKit
import SnapKit
import Then

public enum BottomSheetAlertType {
    case oneButton
    case twoButton
    case verticalTwoButton
}

final class BottomSheetAlertView: UIView {
    private lazy var backgroundView = UIView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private lazy var containerView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray050.color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
    })
    
    private lazy var submitTouchableLabel = TouchableLabel().then {
        $0.text = "회원탈퇴"
        $0.textColor = DesignSystemAsset.white.color
        $0.textAlignment = .center
        $0.font = Font.bold(size: 16)
        $0.backgroundColor = DesignSystemAsset.red050.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var cancelTouchableLabel = TouchableLabel().then {
        $0.text = "취소"
        $0.textColor = DesignSystemAsset.gray700.color
        $0.textAlignment = .center
        $0.font = Font.bold(size: 16)
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var titleStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 12)
        $0.axis = .vertical
        $0.backgroundColor = DesignSystemAsset.gray050.color
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: moderateScale(number: 24),
                                 left: moderateScale(number: 24),
                                 bottom: moderateScale(number: 24),
                                 right: moderateScale(number: 24))
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 24)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let bottomSheetAlertType: BottomSheetAlertType
    
    init(bottomSheetAlertType: BottomSheetAlertType) {
        self.bottomSheetAlertType = bottomSheetAlertType
        super.init(frame: UIScreen.main.bounds)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(title: String,
              description: String?,
              submitLabel: String?,
              cancelLabel: String?,
              submitCompletion: (() -> Void)?,
              cancelCompletion: (() -> Void)?) {
        submitTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            submitCompletion?()
            self?.removeFromSuperview()
        }
        
        cancelTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            cancelCompletion?()
            self?.removeFromSuperview()
        }
        
        titleLabel.text = title
        
        if let subTitle = description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = subTitle
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let submitLabel = submitLabel {
            submitTouchableLabel.text = submitLabel
        }
        
        if let cancelLabel = cancelLabel {
            cancelTouchableLabel.text = cancelLabel
        }
    }
    
    private func addViews() {
        addSubviews([backgroundView, containerView])
        containerView.addSubviews([titleStackView, cancelTouchableLabel, submitTouchableLabel])
        titleStackView.addArrangedSubviews([titleLabel, descriptionLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        switch bottomSheetAlertType {
        case .oneButton:
            submitTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom)
                $0.height.equalTo(moderateScale(number: 52))
                $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 24))
            }
        case .twoButton:
            cancelTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom)
                $0.bottom.equalToSuperview().offset(moderateScale(number: -24))
                $0.leading.equalToSuperview().offset(moderateScale(number: 20))
                $0.height.equalTo(moderateScale(number: 52))
                $0.trailing.equalTo(containerView.snp.centerX).offset(moderateScale(number: -8))
            }
            
            submitTouchableLabel.snp.makeConstraints {
                $0.top.height.equalTo(cancelTouchableLabel)
                $0.leading.equalTo(cancelTouchableLabel.snp.trailing).offset(moderateScale(number: 8))
                $0.trailing.bottom.equalToSuperview().inset(moderateScale(number: 20))
            }
        case .verticalTwoButton:
            submitTouchableLabel.backgroundColor = DesignSystemAsset.main.color
            submitTouchableLabel.textColor = DesignSystemAsset.gray050.color
            
            cancelTouchableLabel.backgroundColor = .clear
            cancelTouchableLabel.textColor = DesignSystemAsset.gray400.color
            
            submitTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(titleStackView.snp.bottom)
                $0.height.equalTo(moderateScale(number: 52))
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 24))
            }
            cancelTouchableLabel.snp.makeConstraints {
                $0.top.equalTo(submitTouchableLabel.snp.bottom)
                $0.height.equalTo(moderateScale(number: 52))
                $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 24))
            }
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }

}
