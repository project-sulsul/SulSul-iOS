//
//  MyFeedCell.swift
//  Feature
//
//  Created by 이범준 on 2024/01/08.
//

import UIKit
import DesignSystem
import Kingfisher // MARK: - 이거 왜 서드파티에 추가 안되냐

final class MyFeedCell: BaseCollectionViewCell<Feed> {
    
    static let reuseIdentifer = "MyFeedCell"
    
    lazy var containerView = TouchableView()
    
    private lazy var dateLabel = UILabel().then({
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var feedImageView = UIImageView().then({
        $0.layer.cornerRadius = moderateScale(number: 20)
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    })
    
    private lazy var feedCountView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 6)
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    })
    
    private lazy var feedCountImageView = UIImageView().then({
        $0.image = UIImage(named: "album")
        $0.contentMode = .scaleAspectFit
    })
    
    private lazy var feedCountLabel = UILabel().then({
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.regular(size: 12)
    })
    
    private lazy var feedTitleLabel = UILabel().then({
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var feedDescriptionLabel = UILabel().then({
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var viewCountImageView = UIImageView().then({
        $0.image = UIImage(named: "eye")
        $0.contentMode = .scaleAspectFit
    })
    
    private lazy var viewCountLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var commentImageView = UIImageView().then({
        $0.image = UIImage(named: "comment")
        $0.contentMode = .scaleAspectFit
    })
    
    private lazy var commentLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var likeImageView = UIImageView().then({
        $0.image = UIImage(named: "like")
        $0.contentMode = .scaleAspectFit
    })
    
    private lazy var likeCountLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var separateView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray100.color
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
        containerView.addSubviews([dateLabel,
                                   feedImageView,
                                   feedCountView,
                                   feedTitleLabel,
                                   feedDescriptionLabel,
                                   viewCountImageView,
                                   viewCountLabel,
                                   commentImageView,
                                   commentLabel,
                                   likeImageView,
                                   likeCountLabel,
                                   separateView])
        feedCountView.addSubviews([feedCountImageView,
                                   feedCountLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: -10))
            $0.trailing.bottom.top.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        feedImageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 353))
        }
        feedCountView.snp.makeConstraints {
            $0.leading.equalTo(feedImageView).offset(moderateScale(number: 16))
            $0.bottom.equalTo(feedTitleLabel.snp.top).offset(moderateScale(number: -4))
            $0.width.equalTo(moderateScale(number: 42))
            $0.height.equalTo(moderateScale(number: 22))
        }
        feedCountImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 16))
        }
        feedCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(feedCountImageView.snp.trailing).offset(moderateScale(number: 2))
        }
        feedTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(feedImageView).offset(moderateScale(number: 16))
            $0.trailing.equalToSuperview().offset(moderateScale(number: -77))
            $0.bottom.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: -16))
        }
        feedDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        viewCountImageView.snp.makeConstraints {
            $0.top.equalTo(feedDescriptionLabel.snp.bottom).offset(moderateScale(number: 11))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.bottom.equalTo(separateView.snp.top).offset(moderateScale(number: -16))
        }
        viewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(viewCountImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        commentImageView.snp.makeConstraints {
            $0.leading.equalTo(viewCountLabel.snp.trailing).offset(moderateScale(number: 16))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        commentLabel.snp.makeConstraints {
            $0.leading.equalTo(commentImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        likeImageView.snp.makeConstraints {
            $0.leading.equalTo(commentLabel.snp.trailing).offset(moderateScale(number: 16))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        separateView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 10))
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func bind(_ model: Feed) {
        super.bind(model)

        feedTitleLabel.text = model.title
        feedDescriptionLabel.text = model.content
        feedCountLabel.text = String(model.images.count + 1)
        viewCountLabel.text = String(model.viewCount)
        commentLabel.text = String(model.commentsCount)
        likeCountLabel.text = String(model.likesCount)
        if let imageURL = URL(string: model.representImage) {
            feedImageView.kf.setImage(with: imageURL)
        }
        
//        1. Ms 저장되는 이슈
//        2. 시간 저장이 제대로 되지 않는 이슈
//        3. 메인 취향쪽 간헐적으로만 보이는 이슈(자동 로그아웃 되서 그런가..?)
        print(">>>>")
        print(model)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let index = model.createdAt.range(of: ".")?.lowerBound {
            let dateString = String(model.createdAt.prefix(upTo: index))
            if let date = dateFormatter.date(from: dateString) {
                dateLabel.text = date.relativeDate(.MM월dd일요일)
            } else {
                dateLabel.text = "날짜 포맷 오류"
            }
        } else {
            if let date = dateFormatter.date(from: model.createdAt) {
                dateLabel.text = date.relativeDate(.MM월dd일요일)
            } else {
                dateLabel.text = "날짜 포맷 오류"
            }
        }
    }
}
