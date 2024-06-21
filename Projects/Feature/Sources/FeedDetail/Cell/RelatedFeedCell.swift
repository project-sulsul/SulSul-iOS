//
//  RelatedFeedCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-13.
//

import UIKit
import DesignSystem

final class RelatedFeedCell: UICollectionViewCell {
    // MARK: - Properties
    //
    static let reuseIdentifier = "RelatedFeedCell"
    
    // MARK: - Components
    //
    private lazy var imageView = UIImageView().then {
        $0.frame = .zero
        $0.backgroundColor = DesignSystemAsset.gray400.color
        $0.layer.cornerRadius = CGFloat(8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var drinkLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.regular(size: 10))
        $0.numberOfLines = 1
        $0.font = Font.regular(size: 10)
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(24, font: Font.bold(size: 18))
        $0.numberOfLines = 1
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var scoreImageView = UIImageView().then {
        $0.image = UIImage(named: "related_feed_score")
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.bold(size: 12))
        $0.font = Font.bold(size: 12)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.drinkLabel.text = nil
        self.scoreLabel.text = nil
        self.imageView.image = nil
    }
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method

extension RelatedFeedCell {
    public func bind(_ model: RelatedFeed) {
        let imageURLString = model.representImage
        if let imageURL = URL(string: imageURLString) {
            self.imageView.kf.setImage(with: imageURL)
        }
        
        self.scoreLabel.text = "\(model.score)/5"
        
        self.drinkLabel.text = model.alcoholTags.first
        
        self.titleLabel.text = model.title
    }
    
    private func addViews() {
        self.addSubview(imageView)
        self.contentView.addSubviews([
            self.titleLabel,
            self.drinkLabel,
            self.scoreImageView,
            self.scoreLabel
        ])
    }
    
    private func makeConstraints() {
        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        self.drinkLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.titleLabel)
            $0.bottom.equalTo(self.titleLabel.snp.top)
        }
        
        self.scoreImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 8))
            $0.bottom.equalTo(self.drinkLabel.snp.top)
        }
        
        self.scoreLabel.snp.makeConstraints {
            $0.leading.equalTo(self.scoreImageView.snp.trailing).offset(moderateScale(number: 2))
            $0.bottom.equalTo(self.drinkLabel.snp.top)
        }
    }
}
