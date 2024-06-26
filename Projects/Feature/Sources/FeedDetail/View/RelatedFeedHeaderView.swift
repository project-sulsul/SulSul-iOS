//
//  RelatedFeedHeaderView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import UIKit
import DesignSystem

final class RelatedFeedHeaderView: UICollectionReusableView {
    static let reuseIdentifier: String = "RelatedFeedHeaderView"
    
    private lazy var separatorView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "feeds")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.text = "연관 피드"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubviews([
            separatorView,
            imageView,
            titleLabel
        ])
    }
    
    private func makeConstraints() {
        separatorView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 10))
        }
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(separatorView.snp.bottom).offset(moderateScale(number: 24))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(moderateScale(number: 8))
            $0.top.equalTo(separatorView.snp.bottom).offset(moderateScale(number: 24))
            $0.centerY.equalTo(imageView)
        }
    }
}
