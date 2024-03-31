//
//  MainPreferenceDetailCell.swift
//  Feature
//
//  Created by 이범준 on 3/2/24.
//

import UIKit
import DesignSystem

final class MainPreferenceDetailCell: UICollectionViewCell {
    
    lazy var containerView = TouchableView().then({
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = 12
    })
    
    private lazy var feedImageView = UIImageView().then({
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .white
    })
    
    private lazy var nickNameLabel = PaddedLabel(padding: .init(top: moderateScale(number: 8),
                                                                     left: moderateScale(number: 16),
                                                                     bottom: moderateScale(number: 8),
                                                                     right: moderateScale(number: 16))).then {
        $0.text = "usernick"
        $0.textAlignment = .center
        $0.font = Font.regular(size: 12)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var foodLabel = PaddedLabel(padding: .init(top: moderateScale(number: 8),
                                                            left: moderateScale(number: 16),
                                                            bottom: moderateScale(number: 8),
                                                            right: moderateScale(number: 16))).then {
        $0.text = "삼겹살"
        $0.textAlignment = .center
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.main.color
        $0.backgroundColor = DesignSystemAsset.gray200.color // TODO: - 색 안나옴
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var scoreImageView = UIImageView().then({
        $0.image = UIImage(named: "rate")
    })
    
    private lazy var scoreLabel = UILabel().then({
        $0.text = "0.0"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.semiBold(size: 12)
    })
    
    private lazy var contentLabel = UILabel().then({
        $0.text = "testesteat awetawe aetw\naweta"
        $0.numberOfLines = 0
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([feedImageView,
                                   foodLabel,
                                   scoreImageView,
                                   scoreLabel,
                                   contentLabel])
        feedImageView.addSubview(nickNameLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        feedImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(moderateScale(number: -128))
        }
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 12))
            $0.bottom.equalToSuperview().offset(moderateScale(number: -8))
        }
        foodLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 12))
            $0.top.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: 16))
        }
        scoreImageView.snp.makeConstraints {
            $0.centerY.equalTo(foodLabel)
            $0.size.equalTo(moderateScale(number: 16))
            $0.trailing.equalTo(scoreLabel.snp.leading)
        }
        scoreLabel.snp.makeConstraints {
            $0.centerY.equalTo(foodLabel)
            $0.trailing.equalToSuperview().offset(moderateScale(number: -12))
        }
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.top.equalTo(foodLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.bottom.equalToSuperview().offset(moderateScale(number: 16))
        }
    }
    
    func bind(_ model: AlcoholFeed.Feed) {
        feedImageView.kf.setImage(with: model.representImage)
        nickNameLabel.text = model.writerNickname
        contentLabel.text = model.title
    }
}
