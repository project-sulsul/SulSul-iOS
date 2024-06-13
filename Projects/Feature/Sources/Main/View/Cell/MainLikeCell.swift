//
//  MainLikeCell.swift
//  Feature
//
//  Created by 이범준 on 3/2/24.
//

import UIKit
import DesignSystem

final class MainLikeCell: UICollectionViewCell {
    
    lazy var containerView = TouchableView().then({
        $0.backgroundColor = .black
    })
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "test 치맥"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 20)
    })
    
    private lazy var arrowImageView = UIImageView().then({
        $0.image = UIImage(named: "common_rightArrow")
    })
    
    private lazy var firstFeedImageView = UIImageView().then({
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.gray050.color
        $0.contentMode = .scaleAspectFill
    })
    
    private lazy var secondFeedImageView = UIImageView().then({
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.maskedCorners = [.layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.gray050.color
        $0.contentMode = .scaleAspectFill
    })
    
    private lazy var thirdFeedImageView = UIImageView().then({
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner]
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = DesignSystemAsset.gray050.color
        $0.contentMode = .scaleAspectFill
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
        containerView.addSubviews([titleLabel,
                                   arrowImageView,
                                   firstFeedImageView,
                                   secondFeedImageView,
                                   thirdFeedImageView])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        firstFeedImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.size.equalTo(moderateScale(number: 232))
            $0.leading.equalToSuperview()
        }
        secondFeedImageView.snp.makeConstraints {
            $0.top.equalTo(firstFeedImageView)
            $0.leading.equalTo(firstFeedImageView.snp.trailing).offset(moderateScale(number: 9))
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(firstFeedImageView.snp.centerY).offset(moderateScale(number: -4))
        }
        thirdFeedImageView.snp.makeConstraints {
            $0.top.equalTo(firstFeedImageView.snp.centerY).offset(moderateScale(number: 4))
            $0.leading.equalTo(firstFeedImageView.snp.trailing).offset(moderateScale(number: 9))
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(firstFeedImageView)
        }
    }
    
    func bind(_ feed: PopularFeed) {
        titleLabel.text = feed.title
        
        let imageViews = [firstFeedImageView, secondFeedImageView, thirdFeedImageView]
        
        for index in 0..<feed.feeds.count {
            if let url = URL(string: feed.feeds[index].representImage ?? "") {
                if index <= imageViews.count {
                    imageViews[index].kf.setImage(with: url)
                }
            } else {
                print("사진 없어")
            }
        }
    }
}
