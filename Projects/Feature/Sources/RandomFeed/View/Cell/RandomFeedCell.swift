//
//  RandomFeedCell.swift
//  Feature
//
//  Created by 김유진 on 3/7/24.
//

import UIKit
import Service
import DesignSystem

final class RamdomFeedCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var profileImage  = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 16)
    }
    
    private lazy var relateDataLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.regular(size: 14)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 24)
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray500.color
        $0.font = Font.medium(size: 14)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 2
    }
    
    lazy var seeAllLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.semiBold(size: 12)
        $0.text = "전체보기"
    }
    
    lazy var heartView = UIView()
    
    private lazy var heartImageView = UIImageView().then {
        $0.image = UIImage(named: "randomFeed_heart")
    }
    
    private lazy var heartCountLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.regular(size: 12)
    }
    
    lazy var spamView = UIView()
    
    private lazy var spamImageView = UIImageView().then {
        $0.image = UIImage(named: "randomFeed_spam")
    }
    
    private lazy var spamCountLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.regular(size: 12)
        $0.text = "신고"
    }
    
    private lazy var topGradientLayer = CAGradientLayer()
    private lazy var bottomGradientLayer = CAGradientLayer()
    
    private lazy var topGradientView = UIView().then {
        topGradientLayer.colors = [DesignSystemAsset.black.color.cgColor,
                                   DesignSystemAsset.black.color.withAlphaComponent(0.1),
                                   UIColor.clear.cgColor]
        topGradientLayer.opacity = 1
        topGradientLayer.locations = [0, 0.2]
        $0.layer.addSublayer(topGradientLayer)
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(moderateScale(number: 400)))
    }
    
    private lazy var bottomGradientView = UIView().then {
        bottomGradientLayer.colors = [UIColor.clear.cgColor,
                                      DesignSystemAsset.black.color.withAlphaComponent(0.1),
                                      DesignSystemAsset.black.color.cgColor]
        bottomGradientLayer.opacity = 1
        bottomGradientLayer.locations = [0, 0.2]
        $0.layer.addSublayer(bottomGradientLayer)
        bottomGradientLayer.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(moderateScale(number: 270)))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ randomFeed: RandomFeedModel.Feed) {
        profileImage.backgroundColor = .lightGray
        titleLabel.text = randomFeed.title
        contentLabel.text = randomFeed.content
        nameLabel.text = randomFeed.user_nickname
        heartCountLabel.text = "\(randomFeed.likes_count)"
        
        if let imageURL = URL(string: randomFeed.user_image ?? "") {
            profileImage.kf.setImage(with: imageURL)
        } else {
            profileImage.image = UIImage(named: "randomFeed_profile")
        }
        
        if let imageURL = URL(string: randomFeed.represent_image) {
            imageView.kf.setImage(with: imageURL)
        }
        
        if UserDefaultsUtil.shared.isLogin(), randomFeed.is_liked {
            heartImageView.image = UIImage(named: "randomFeed_heartFill")
            
        } else {
            heartImageView.image = UIImage(named: "randomFeed_heart")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: randomFeed.updated_at) {
            relateDataLabel.text = date.relativeDate()
        }
    }
}

extension RamdomFeedCell {
    private func addViews() {
        addSubviews([
            imageView,
            topGradientView,
            bottomGradientView,
            seeAllLabel,
            contentLabel,
            titleLabel,
            profileImage,
            nameLabel,
            relateDataLabel,
            heartView,
            spamView
        ])
        
        heartView.addSubviews([
            heartImageView,
            heartCountLabel
        ])
        
        spamView.addSubviews([
            spamImageView,
            spamCountLabel
        ])
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topGradientView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 400))
            $0.top.leading.trailing.equalToSuperview()
        }
        
        bottomGradientView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 270))
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        seeAllLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.bottom.equalTo(seeAllLabel.snp.top).offset(moderateScale(number: -4))
            $0.trailing.equalTo(spamView.snp.leading).offset(moderateScale(number: -24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.centerX.equalTo(contentLabel)
            $0.bottom.equalTo(contentLabel.snp.top).offset(moderateScale(number: -4))
        }
        
        profileImage.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalTo(titleLabel.snp.top).offset(moderateScale(number: -8))
            $0.size.equalTo(moderateScale(number: 32))
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(moderateScale(number: 12))
        }
        
        relateDataLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(moderateScale(number: 12))
        }
        
        spamView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 44))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 24))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        spamImageView.snp.makeConstraints {
            $0.centerX.top.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        spamCountLabel.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
        }
        
        heartView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 44))
            $0.trailing.equalTo(spamView)
            $0.bottom.equalTo(spamView.snp.top).offset(moderateScale(number: -24))
        }
        
        heartImageView.snp.makeConstraints {
            $0.centerX.top.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
        }
    }
}
