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
    
    private lazy var drinkLabel = PaddedLabel(padding: .init(top: moderateScale(number: 8),
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
    
    private lazy var andLabel = UILabel().then({
        $0.text = "&"
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
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
                                   drinkLabel,
                                   andLabel,
                                   foodLabel,
                                   scoreImageView,
                                   scoreLabel,
                                   contentLabel,
                                   detailContentLabel])
        feedImageView.addSubview(nickNameLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        feedImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 264))
        }
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 12))
            $0.bottom.equalToSuperview().offset(moderateScale(number: -8))
        }
        drinkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 12))
            $0.top.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: 16))
        }
        andLabel.snp.makeConstraints {
            $0.centerY.equalTo(drinkLabel)
            $0.leading.equalTo(drinkLabel.snp.trailing).offset(moderateScale(number: 10.86))
        }
        foodLabel.snp.makeConstraints {
            $0.centerY.equalTo(drinkLabel)
            $0.leading.equalTo(andLabel.snp.trailing).offset(moderateScale(number: 10.86))
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
        }
        detailContentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.top.equalTo(contentLabel.snp.bottom).offset(moderateScale(number: 6))
            $0.bottom.equalToSuperview().offset(moderateScale(number: -16))
        }
    }
    
    func bind(_ feed: PopularFeed) {
//        for index in 0..<feed.feeds.count {
//            if let url = URL(string: feed.feeds[index].representImage ?? "") {
//                
//            } else {
//                print("사진 없어")
//            }
//        }
        for feed in feed.feeds {
            contentLabel.text = feed.title
            detailContentLabel.text = feed.content
            nickNameLabel.text = feed.userNickname
            if let url = URL(string: feed.representImage) {
                feedImageView.kf.setImage(with: url)
            } else {
                print("사진 읎어")
            }
        }
    }
}
