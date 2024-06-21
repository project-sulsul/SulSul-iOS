//
//  CommentTextFieldView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-21.
//

import UIKit
import DesignSystem

final class CommentTextFieldView: UIView {
    lazy var textField = PaddableTextField(to: 12).then {
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.autocapitalizationType = .none
        $0.placeholder = "댓글을 입력해볼까요?"
        $0.isEnabled = false
    }
    
    lazy var touchableLabel = TouchableLabel().then {
        $0.setLineHeight(24, font: Font.semiBold(size: 16))
        $0.frame = .zero
        $0.font = Font.semiBold(size: 16)
        $0.text = "등록"
        $0.textColor = DesignSystemAsset.gray500.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = DesignSystemAsset.black.color
        self.layer.borderColor = DesignSystemAsset.gray300.color.cgColor
        self.layer.cornerRadius = CGFloat(8)
        self.layer.borderWidth = CGFloat(1)
        self.layer.masksToBounds = true
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubviews([textField, touchableLabel])
    }
    
    private func makeConstraints() {
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(touchableLabel.snp.leading)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        touchableLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalTo(textField)
            $0.height.equalTo(textField)
        }
    }
}
