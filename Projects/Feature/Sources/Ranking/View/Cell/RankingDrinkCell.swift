//
//  RankingDrinkCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

final class RankingDrinkCell: BaseCollectionViewCell<RankingItem> {
    
    static let reuseIdentifier = "RankingDrinkCell"
    
    private lazy var containerView = UIView().then {
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    private lazy var rankLabel = UILabel().then {
        $0.setLineHeight(36, font: Font.bold(size: 24))
        $0.font = Font.bold(size: 24)
        $0.textAlignment = .center
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var variationLabel = UILabel().then {
        $0.setLineHeight(32, font: Font.bold(size: 20))
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.text = "-"
    }
    
    private lazy var variationImageView = UIImageView().then {
        $0.image = UIImage(named: "rise_arrow")
    }
    
    private lazy var drinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var subtypeContainerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = CGFloat(8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var subtypeLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.regular(size: 12))
        $0.font = Font.regular(size: 12)
        $0.textAlignment = .center
        $0.textColor = DesignSystemAsset.gray700.color
    }
    
    private lazy var drinkNameLabel = UILabel().then {
        $0.setLineHeight(32, font: Font.bold(size: 20))
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        rankLabel.text = nil
        drinkImageView.image = nil
        drinkNameLabel.text = nil
        subtypeLabel.text = nil
    }
    
    override func bind(_ model: RankingItem) {
        super.bind(model)
        
        configure(model)
    }
}

// MARK: - Custom Method

extension RankingDrinkCell {
    private func addViews() {
        addSubview(containerView)
        subtypeContainerView.addSubview(subtypeLabel)
        containerView.addSubviews([
            rankLabel,
            variationLabel,
            variationImageView,
            drinkImageView,
            subtypeContainerView,
            drinkNameLabel
        ])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rankLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(moderateScale(number: 10))
            $0.trailing.equalTo(variationLabel.snp.trailing)
            $0.top.equalToSuperview().offset(moderateScale(number: 13))
        }
        variationImageView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel)
            $0.top.equalTo(rankLabel.snp.bottom)
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 19))
        }
        variationLabel.snp.makeConstraints {
            $0.leading.equalTo(variationImageView.snp.trailing)
            $0.top.equalTo(rankLabel.snp.bottom)
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 19))
        }
        drinkImageView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(moderateScale(number: 27))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 70))
        }
        subtypeContainerView.snp.makeConstraints {
            $0.leading.equalTo(drinkNameLabel)
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
            $0.bottom.equalTo(drinkNameLabel.snp.top).offset(-moderateScale(number: 2))
            $0.height.equalTo(moderateScale(number: 20))
        }
        subtypeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().offset(-moderateScale(number: 8))
            $0.top.equalToSuperview().offset(moderateScale(number: 2))
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 2))
        }
        drinkNameLabel.snp.makeConstraints {
            $0.leading.equalTo(drinkImageView.snp.trailing).offset(moderateScale(number: 20))
            $0.trailing.equalToSuperview().offset(-moderateScale(number: 10))
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 16))
        }
    }
    
    private func configure(_ model: RankingItem) {
        if let rank = model.rank {
            rankLabel.text = String(rank)
        } else {
            print("Rank value is not available.")
        }
        
        if let imageURLString = model.drink?.image,
           let imageURL = URL(string: imageURLString) {
            drinkImageView.loadImage(imageURL)
        } else {
            print("Image URL is not available.")
            drinkImageView.image = UIImage()
        }
        
        if let subtype = model.drink?.subtype {
            subtypeLabel.text = String(subtype)
        } else {
            print("Subtype value is not available.")
        }
        
        if let drinkName = model.drink?.name {
            drinkNameLabel.text = drinkName
        } else {
            print("Drink name is not available.")
        }
    }
}
