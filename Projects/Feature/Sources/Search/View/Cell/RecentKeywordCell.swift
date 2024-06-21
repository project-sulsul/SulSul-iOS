//
//  RecentKeywordCell.swift
//  Feature
//
//  Created by 김유진 on 2024/01/11.
//

import UIKit
import DesignSystem

final class RecentKeywordCell: BaseCollectionViewCell<String> {
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var keywordLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray700.color
        $0.font = Font.bold(size: 16)
    }
    
    lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "search_resentKeywordDelete")?.withTintColor(DesignSystemAsset.gray300.color), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addViews()
        makeConstraints()
    }
    
    override func bind(_ keyword: String) {
        keywordLabel.text = keyword
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let inset = moderateScale(number: 57)
        
        let screenWidth = UIScreen.main.bounds.width - moderateScale(number: 50)
        var labelWidth = keywordLabel.intrinsicContentSize.width + inset
        
        if screenWidth < labelWidth {
            labelWidth = moderateScale(number: screenWidth)
        }
        
        layoutAttributes.frame = CGRect(x: 0, y: 0, width: labelWidth, height: moderateScale(number: 40))
        return layoutAttributes
    }
}

extension RecentKeywordCell {
    private func addViews() {
        addSubviews([
            containerView,
            keywordLabel,
            deleteButton
        ])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        keywordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 14))
            $0.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(keywordLabel.snp.trailing).offset(moderateScale(number: 6))
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
