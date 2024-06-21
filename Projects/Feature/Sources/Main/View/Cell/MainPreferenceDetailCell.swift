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
        $0.clipsToBounds = true
    })
    
    private lazy var feedImageView = UIImageView().then({
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    })
    
    private lazy var nickNameView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 8)
    })
    
    private lazy var nickNameLabel = UILabel().then({
        $0.font = Font.regular(size: 12)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var foodView = UIView().then({
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 0.1)
    })
    
    private lazy var foodLabel = UILabel().then({
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.main.color
    })
    
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
        $0.lineBreakMode = .byWordWrapping
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
                                   foodView,
                                   nickNameView,
                                   scoreImageView,
                                   scoreLabel,
                                   contentLabel])
        foodView.addSubview(foodLabel)
        nickNameView.addSubview(nickNameLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        feedImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 195))
        }
        nickNameView.snp.makeConstraints {
            $0.leading.equalTo(feedImageView).offset(moderateScale(number: 12))
            $0.bottom.equalTo(feedImageView).offset(moderateScale(number: -8))
        }
        nickNameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 4))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
        }
        foodView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 12))
            $0.top.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: 16))
        }
        foodLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 4))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        scoreImageView.snp.makeConstraints {
            $0.centerY.equalTo(foodView)
            $0.size.equalTo(moderateScale(number: 16))
            $0.trailing.equalTo(scoreLabel.snp.leading)
        }
        scoreLabel.snp.makeConstraints {
            $0.centerY.equalTo(foodView)
            $0.trailing.equalToSuperview().offset(moderateScale(number: -12))
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(foodView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
        }
    }
    
    func bind(_ model: AlcoholFeed.Feed) {
        feedImageView.kf.setImage(with: model.representImage)
        nickNameLabel.text = "@" + model.writerNickname
        contentLabel.text = model.title
        foodLabel.text = model.foods.first
    }
}
