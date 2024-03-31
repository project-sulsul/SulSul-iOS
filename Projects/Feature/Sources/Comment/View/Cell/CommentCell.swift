//
//  CommentCell.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import UIKit
import DesignSystem

final class CommentCell: UITableViewCell {
    static let id = "CommentCell"
    
    private lazy var contentAndReplyStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderateScale(number: 8)
        $0.alignment = .center
    }
    
    private lazy var profileIamgeView = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 8)
        $0.alignment = .leading
    }
    
    private lazy var userInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = moderateScale(number: 8)
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = Font.bold(size: 14)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.font = Font.regular(size: 10)
        $0.textColor = DesignSystemAsset.gray300.color
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray700.color
        $0.numberOfLines = 0
    }
    
    private lazy var tagLabel = UILabel().then {
        $0.font = Font.regular(size: 10)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 4)
    }
    
    private lazy var replyImageView = UIImageView().then {
        $0.image = UIImage(named: "comment_reply")
    }
    
    lazy var replayLabel = UILabel().then {
        $0.font = Font.semiBold(size: 12)
        $0.textColor = DesignSystemAsset.gray300.color
        $0.text = "답글 달기"
    }
    
    private lazy var writerStackView = UIStackView().then {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: moderateScale(number: 1),
                                 left: moderateScale(number: 4),
                                 bottom: moderateScale(number: 1),
                                 right: moderateScale(number: 4))
        $0.backgroundColor = DesignSystemAsset.main.color.withAlphaComponent(0.1)
        $0.layer.cornerRadius = moderateScale(number: 4)
    }
    
    private lazy var writerLabel = UILabel().then {
        $0.font = Font.regular(size: 10)
        $0.textColor = DesignSystemAsset.main.color
        $0.text = "작성자"
    }
    
    lazy var moreButton = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_progress")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = DesignSystemAsset.black.color
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ comment: Comment) {
        if let url = URL(string: comment.user_info.image ?? "") {
            profileIamgeView.kf.setImage(with: url)
        } else {
            profileIamgeView.image = UIImage(named: "randomFeed_profile")
        }
        
        if let comments = comment.children_comments, comments.count > 0 {
            replayLabel.text = "답글 \(comments.count)개  ・  답글 달기"
        } else {
            replayLabel.text = "답글 달기"
        }

        if let isChildren = comment.isChildren {
            replyImageView.isHidden = false
            replayLabel.isHidden = true
        } else {
            replayLabel.isHidden = false
            replyImageView.isHidden = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: comment.updated_at) {
            dateLabel.text = date.relativeDate(.MM월dd일)
        }
        
        nameLabel.text = comment.user_info.nickname
        contentLabel.text = comment.content
        
        writerStackView.isHidden = !comment.is_writer
    }
}

extension CommentCell {
    private func addViews() {
        contentView.addSubview(contentAndReplyStackView)
        contentView.addSubview(moreButton)
        
        contentAndReplyStackView.addArrangedSubview(replyImageView)
        contentAndReplyStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(userInfoStackView)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(replayLabel)
        
        userInfoStackView.addArrangedSubview(profileIamgeView)
        userInfoStackView.addArrangedSubview(nameLabel)
        userInfoStackView.addArrangedSubview(writerStackView)
        writerStackView.addArrangedSubview(writerLabel)
        userInfoStackView.addArrangedSubview(dateLabel)
    }
    
    private func makeConstraints() {
        contentAndReplyStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 12))
        }
        replyImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        profileIamgeView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 8))
            $0.trailing.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
