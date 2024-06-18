//
//  ValidationLabelStackView.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import UIKit
import DesignSystem

internal final class ValidationLabelStackView: UIStackView {
    
    enum ValidationState: CaseIterable {
        case begin, common, nonpass, pass
        
        var image: String {
            switch self {
            case .begin: return "reply_filled_arrow"
            case .common: return "common_checkmark"
            case .pass: return "checkmark"
            case .nonpass: return "xmark"
            }
        }
        
        var color: UIColor {
            switch self {
            case .begin: return DesignSystemAsset.gray500.color
            case .common: return DesignSystemAsset.gray700.color
            case .nonpass: return UIColor(red: 255/255, green: 91/255, blue: 85/255, alpha: 1)
            case .pass: return UIColor(red: 127/255, green: 239/255, blue: 118/255, alpha: 1)
            }
        }
    }
    
    private lazy var imageView = UIImageView()
    
    private lazy var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(to: .begin, "닉네임을 입력해주세요.")
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addArrangedSubviews([imageView, textLabel])
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.height)
        }
    }
}

extension ValidationLabelStackView {
    internal func configure(to state: ValidationState, _ text: String) {
        imageView.image = UIImage(named: state.image)
        textLabel.font = Font.regular(size: 14)
        textLabel.textColor = state.color
        textLabel.text = text
    }
}
