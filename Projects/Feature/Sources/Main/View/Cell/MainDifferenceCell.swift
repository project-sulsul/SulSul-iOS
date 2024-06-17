//
//  MainDifferenceCell.swift
//  Feature
//
//  Created by 이범준 on 3/3/24.
//

import UIKit
import DesignSystem

final class MainDifferenceCell: UICollectionViewCell {
    
    lazy var containerView = TouchableView().then({
        $0.backgroundColor = .black
    })
    
    private lazy var feedImageView = UIImageView().then({
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    })
    
    private lazy var nickNameView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 12)
    })
    
    private lazy var nickNameLabel = UILabel().then({
        $0.font = Font.regular(size: 12)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var drinkView = UIView().then({
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 0.1)
    })
    
    private lazy var drinkLabel = UILabel().then({
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.main.color
    })
    
    private lazy var andLabel = UILabel().then({
        $0.text = "&"
        $0.font = Font.bold(size: 20)
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
        $0.text = "testesteat awetawe "
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    })
    
    private lazy var detailContentLabel = UILabel().then({
        $0.text = "위스키가 어쩌고 저쩌고\n궁시렁궁시렁 야야"
        $0.textColor = DesignSystemAsset.gray800.color
        $0.font = Font.medium(size: 14)
        $0.numberOfLines = 0
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
                                   drinkView,
                                   andLabel,
                                   foodView,
                                   scoreImageView,
                                   scoreLabel,
                                   contentLabel,
                                   nickNameView,
                                   detailContentLabel])
        drinkView.addSubview(drinkLabel)
        foodView.addSubview(foodLabel)
        nickNameView.addSubview(nickNameLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        feedImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 264))
        }
        nickNameView.snp.makeConstraints {
            $0.leading.equalTo(feedImageView).offset(moderateScale(number: 12))
            $0.bottom.equalTo(feedImageView).offset(moderateScale(number: -8))
        }
        nickNameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        drinkView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 12))
            $0.top.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: 16))
        }
        drinkLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        andLabel.snp.makeConstraints {
            $0.centerY.equalTo(drinkView)
            $0.leading.equalTo(drinkView.snp.trailing).offset(moderateScale(number: 10.86))
        }
        foodView.snp.makeConstraints {
            $0.centerY.equalTo(drinkLabel)
            $0.leading.equalTo(andLabel.snp.trailing).offset(moderateScale(number: 10.86))
        }
        foodLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
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
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.top.equalTo(foodView.snp.bottom).offset(moderateScale(number: 8))
        }
        detailContentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.top.equalTo(contentLabel.snp.bottom).offset(moderateScale(number: 6))
            $0.bottom.equalToSuperview().offset(moderateScale(number: -16))
        }
    }
    
    func bind(_ feed: PopularFeed) {
        for feed in feed.feeds {
            contentLabel.text = feed.title
            detailContentLabel.text = feed.content
            nickNameLabel.text = "@" + feed.userNickname
            if let url = URL(string: feed.representImage) {
                feedImageView.kf.setImage(with: url)
            } else {
                print("사진 읎어")
            }
            drinkLabel.text = StaticValues.getDrinkPairingById(feed.pairingIds.first ?? 0)?.name
            foodLabel.text = StaticValues.getSnackPairingById(feed.pairingIds.last ?? 0)?.name
            scoreLabel.text = "\(feed.score)"
        }
    }
}
