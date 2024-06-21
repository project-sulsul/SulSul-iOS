//
//  DetailMainCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import UIKit
import DesignSystem

final class DetailMainCell: UICollectionViewCell {
    // MARK: - Properties
    //
    static let reuseIdentifier: String = "FeedDetailMainCell"
    
    // MARK: - Components
    //
    private lazy var containerView = UIView(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    private lazy var userTagCollectionView = UserTagCollectionView(frame: .zero)
    
    private lazy var indicatorView = UIView().then {
        $0.layer.cornerRadius = CGFloat(2)
        $0.backgroundColor = DesignSystemAsset.main.color
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = CGFloat(20)
        $0.layer.masksToBounds = true
    }
    
    private lazy var usernameLabel = UILabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var createdAtLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.regular(size: 10))
        $0.font = Font.regular(size: 10)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.bold(size: 10.7))
        $0.font = Font.bold(size: 10.7)
        $0.textColor = DesignSystemAsset.main.color
    }
    
    private lazy var scoreLevelImageView = UIImageView()
    
    private lazy var drinkLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18, font: Font.semiBold(size: 12))
        $0.font = Font.semiBold(size: 12)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var snackLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18, font: Font.semiBold(size: 12))
        $0.font = Font.semiBold(size: 12)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var textView = UITextView().then {
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.isSelectable = true
        $0.font = Font.medium(size: 16)
        $0.backgroundColor = .clear
        $0.textColor = DesignSystemAsset.gray800.color
    }
    
    private lazy var feedViewsImageView = UIImageView().then {
        $0.image = UIImage(named: "views")
    }
    
    private lazy var feedCommentsImageView = UIImageView().then {
        $0.image = UIImage(named: "comments")
    }
    
    private lazy var feedLikesImageView = UIImageView().then {
        $0.image = UIImage(named: "likes")
    }
    
    private lazy var feedViewsLabel = UILabel().then {
        $0.setLineHeight(22, font: Font.medium(size: 14))
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedCommentsLabel = UILabel().then {
        $0.setLineHeight(22, font: Font.medium(size: 14))
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedLikesLabel = UILabel().then {
        $0.setLineHeight(22, font: Font.medium(size: 14))
        $0.font = Font.medium(size: 14)
        $0.text = "0"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var feedViewsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([self.feedViewsImageView, self.feedViewsLabel])
    }
    
    private lazy var feedCommentsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([self.feedCommentsImageView, self.feedCommentsLabel])
    }
    
    private lazy var feedLikesStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.distribution = .fillEqually
        $0.addArrangedSubviews([self.feedLikesImageView, self.feedLikesLabel])
    }
    
    private lazy var separatorView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var carouselView = CarouselView(frame: .zero)
    
    lazy var pairingStackView = PairingStackView(frame: .zero)
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.containerView.isHidden = true
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method
//
extension DetailMainCell {
    func bind(_ model: FeedDetail) {
        self.carouselView.bind(model)
        
        self.updateScore(to: model.score)
        
        self.textView.text = model.content
        self.updateTextViewHeight(textView)

        self.feedViewsLabel.text = String(model.viewCount)
        self.feedCommentsLabel.text = String(model.commentCount)
        self.feedLikesLabel.text = String(model.likeCount)
        
        if let userTags = model.userTags {
            self.updateUserTags(to: userTags)
        } else {
            self.updateUserTags(to: [])
        }
        
        if let username = model.writerInfo?.nickname {
            self.usernameLabel.text = username
        } else {
            self.usernameLabel.text = "알 수 없음"
        }
        
        if let profileImageURL = model.writerInfo?.image,
           let profileImage = URL(string: profileImageURL) {
            profileImageView.loadImage(profileImage)
        } else {
            self.profileImageView.image = UIImage(named: "detail_profile")
        }
        
        let dateFormatter = DateFormatter()
        // 기존 yyyy-MM-dd'T'HH:mm:ss 형식이 아닌 초의 소수점까지 서버에서 전달하고 있음
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        if let createdAtDate = dateFormatter.date(from: model.createdAt) {
            let displayDateFormat = DateFormatter()
            displayDateFormat.dateFormat = "yy.MM.dd"
            
            self.createdAtLabel.text = displayDateFormat.string(from: createdAtDate)
        } else {
            self.createdAtLabel.text = model.createdAt
        }
        
        self.containerView.isHidden = false
    }
    
    private func addViews() {
        self.containerView.addSubviews([
            self.carouselView, 
            self.indicatorView,
            self.profileImageView, 
            self.usernameLabel,
            self.createdAtLabel, 
            self.textView,
            self.scoreLabel, 
            self.scoreLevelImageView,
            self.feedViewsStackView, 
            self.feedCommentsStackView,
            self.feedLikesStackView, 
            self.pairingStackView,
            self.userTagCollectionView,
            self.separatorView
        ])
        
        self.addSubview(self.containerView)
    }
    
    private func makeConstraints() {
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.carouselView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview().inset(moderateScale(number: 4))
            $0.size.equalTo(moderateScale(number: 353))
        }
        
        self.profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(self.carouselView.snp.bottom).offset(moderateScale(number: 24))
            $0.size.equalTo(moderateScale(number: 40))
        }
        
        self.usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(moderateScale(number: 12))
            $0.top.equalTo(self.carouselView.snp.bottom).offset(moderateScale(number: 24))
        }
        
        self.scoreLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.scoreLevelImageView.snp.leading).offset(moderateScale(number: -7.11))
            $0.top.equalTo(self.carouselView.snp.bottom).offset(moderateScale(number: 27))
        }
        
        self.scoreLevelImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(self.scoreLabel)
        }
        
        self.pairingStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(self.scoreLabel.snp.bottom).offset(moderateScale(number: 2))
        }
        
        self.createdAtLabel.snp.makeConstraints {
            $0.leading.equalTo(usernameLabel)
            $0.top.equalTo(self.usernameLabel.snp.bottom).offset(moderateScale(number: 8))
        }
        
        self.textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 144))
        }
        
        self.userTagCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.textView)
            $0.top.equalTo(self.textView.snp.bottom).offset(moderateScale(number: 32))
            $0.bottom.equalTo(self.feedViewsStackView.snp.top).offset(-moderateScale(number: 16))
            $0.height.lessThanOrEqualTo(moderateScale(number: 48))
        }
        
        self.feedViewsStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.bottom.equalTo(self.separatorView.snp.top).offset(-moderateScale(number: 22))
        }
        
        self.feedCommentsStackView.snp.makeConstraints {
            $0.leading.equalTo(self.feedViewsStackView.snp.trailing).offset(moderateScale(number: 16))
            $0.bottom.equalTo(self.feedViewsStackView)
        }
        
        self.feedLikesStackView.snp.makeConstraints {
            $0.leading.equalTo(self.feedCommentsStackView.snp.trailing).offset(moderateScale(number: 16))
            $0.bottom.equalTo(self.feedViewsStackView)
        }
        
        self.separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 10))
        }
    }
    
    private func updateUserTags(to tags: [String]) {
        if !tags.isEmpty {
            self.userTagCollectionView.bind(tags)
        }
        
        if tags.isEmpty || tags.first == "#" && tags.count == 1 {
            self.userTagCollectionView.removeFromSuperview()
            
            self.feedViewsStackView.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(moderateScale(number: 20))
                $0.top.equalTo(self.textView.snp.bottom).offset(moderateScale(number: 32))
                $0.bottom.equalTo(self.separatorView.snp.top).offset(-moderateScale(number: 22))
            }
            
            self.feedCommentsStackView.snp.remakeConstraints {
                $0.leading.equalTo(self.feedViewsStackView.snp.trailing).offset(moderateScale(number: 16))
                $0.top.equalTo(self.feedViewsStackView)
                $0.bottom.equalTo(feedViewsStackView)
            }
            
            self.feedLikesStackView.snp.remakeConstraints {
                $0.leading.equalTo(self.feedCommentsStackView.snp.trailing).offset(moderateScale(number: 16))
                $0.top.equalTo(self.feedViewsStackView)
                $0.bottom.equalTo(self.feedViewsStackView)
            }
        }
    }
    
    private func updateScore(to score: Int) {
        switch score {
        case 5:
            self.scoreLabel.text = "5점"
            self.scoreLevelImageView.image = UIImage(named: "score_level_5")
        case 4:
            self.scoreLabel.text = "4점"
            self.scoreLevelImageView.image = UIImage(named: "score_level_4")
        case 3:
            self.scoreLabel.text = "3점"
            self.scoreLevelImageView.image = UIImage(named: "score_level_3")
        case 2:
            self.scoreLabel.text = "2점"
            self.scoreLevelImageView.image = UIImage(named: "score_level_2")
        case 1:
            self.scoreLabel.text = "1점"
            self.scoreLevelImageView.image = UIImage(named: "score_level_1")
        default:
            self.scoreLabel.text = "0점"
            self.scoreLevelImageView.image = UIImage(named: "score_level_0")
        }
    }
    
    private func updateTextViewHeight(_ textView: UITextView) {
        let contentSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        textView.snp.updateConstraints {
            $0.height.equalTo(contentSize.height)
        }
        
        self.layoutIfNeeded()
    }
}
