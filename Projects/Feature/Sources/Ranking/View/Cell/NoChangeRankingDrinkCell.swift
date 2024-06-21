//
//  NoChangeRankingDrinkCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-15.
//

import UIKit
import DesignSystem

final class NoChangeRankingDrinkCell: BaseCollectionViewCell<RankingItem> {
    // MARK: - Properties
    //
    static let reuseIdentifier = "NoChangeRankingDrinkCell"
    
    // MARK: - Components
    //
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rankLabel.text = nil
        self.drinkImageView.image = nil
        self.drinkNameLabel.text = nil
        self.subtypeLabel.text = nil
    }
    
    override func bind(_ model: RankingItem) {
        super.bind(model)
        
        if let rank = model.rank {
            self.rankLabel.text = String(rank)
        } else {
            debugPrint("\(#fileID) >>>> Rank value is not available.")
        }
        
        if let imageURLString = model.drink?.image,
           let imageURL = URL(string: imageURLString) {
            self.drinkImageView.loadImage(imageURL)
        } else {
            debugPrint("\(#fileID) >>>> Image URL is not available.")
            self.drinkImageView.image = UIImage()
        }
        
        if let subtype = model.drink?.subtype {
            self.subtypeLabel.text = String(subtype)
        } else {
            debugPrint("\(#fileID) >>>> Subtype value is not available.")
        }
        
        if let drinkName = model.drink?.name {
            self.drinkNameLabel.text = drinkName
        } else {
            debugPrint("\(#fileID) >>>> Drink name is not available.")
        }
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

// MARK: - Custom Method
//
extension NoChangeRankingDrinkCell {
    private func addViews() {
        self.addSubview(containerView)
        
        self.subtypeContainerView.addSubview(subtypeLabel)
        
        self.containerView.addSubviews([
            self.rankLabel,
            self.drinkImageView,
            self.subtypeContainerView,
            self.drinkNameLabel
        ])
    }
    
    private func makeConstraints() {
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.rankLabel.snp.makeConstraints {
            $0.leading.equalTo(self.containerView.snp.leading).offset(moderateScale(number: 10))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 13))
            $0.width.equalTo(moderateScale(number: 40))
        }
        
        self.drinkImageView.snp.makeConstraints {
            $0.leading.equalTo(self.rankLabel.snp.trailing).offset(moderateScale(number: 16))
            $0.trailing.equalTo(self.drinkNameLabel.snp.leading).offset(-moderateScale(number: 16))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 70))
        }
        
        self.subtypeContainerView.snp.makeConstraints {
            $0.leading.equalTo(self.drinkNameLabel)
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
            $0.bottom.equalTo(self.drinkNameLabel.snp.top).offset(-moderateScale(number: 2))
            $0.height.equalTo(moderateScale(number: 20))
        }
        
        self.subtypeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.top.equalToSuperview().offset(moderateScale(number: 2))
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 2))
        }
        
        self.drinkNameLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-moderateScale(number: 10))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
}
