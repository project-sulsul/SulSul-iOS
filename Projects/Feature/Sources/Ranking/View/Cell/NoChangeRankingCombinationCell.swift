//
//  NoChangeRankingCombinationCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-16.
//

import UIKit
import DesignSystem

final class NoChangeRankingCombinationCell: BaseCollectionViewCell<RankingItem> {
    // MARK: - Properties
    //
    static let reuseIdentifier = "NoChangeRankingCombinationCell"
    
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
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }
    
    private lazy var snackImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }
    
    private lazy var drinkNameLabel = UILabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var snackNameLabel = UILabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = -24
        $0.distribution = .fillEqually
    }
    
    private lazy var nameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rankLabel.text = nil
        self.drinkNameLabel.text = nil
        self.snackNameLabel.text = nil
        self.drinkImageView.image = nil
        self.snackImageView.image = nil
    }
    
    override func bind(_ model: RankingItem) {
        super.bind(model)
        
        if let rank = model.rank {
            self.rankLabel.text = String(rank)
        } else {
            debugPrint("\(#fileID) >>>> Rank value is not available.")
        }
        
        if let pairings = model.pairings, pairings.count >= 2 {
            if let drinkName = pairings[0].name {
                self.drinkNameLabel.text = drinkName
            }
            
            if let snackName = pairings[1].name {
                self.snackNameLabel.text = "& " + snackName
            }
            
            if let drinkImageURLString = pairings[0].image, let drinkImageURL = URL(string: drinkImageURLString) {
                self.drinkImageView.kf.setImage(with: drinkImageURL)
            } else {
                self.drinkImageView.image = nil
                debugPrint("\(#fileID) >>>> Drink Image URL is not available.")
            }
            
            if let snackImageURLString = pairings[1].image, let snackImageURL = URL(string: snackImageURLString) {
                self.snackImageView.kf.setImage(with: snackImageURL)
            } else {
                self.snackImageView.image = nil
                debugPrint("\(#fileID) >>>> Snack Image URL is not available.")
            }
        } else {
            debugPrint("\(#fileID) >>>> Pairings data is not available")
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

// MARK: - Custom methods
//
extension NoChangeRankingCombinationCell {
    private func addViews() {
        self.addSubview(self.containerView)
        
        self.containerView.addSubviews([
            self.rankLabel,
            self.imageStackView,
            self.nameStackView
        ])
        
        self.imageStackView.addArrangedSubviews([
            self.drinkImageView, 
            self.snackImageView
        ])
        
        self.imageStackView.bringSubviewToFront(self.drinkImageView)
        
        self.nameStackView.addArrangedSubviews([
            self.drinkNameLabel,
            self.snackNameLabel
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
            $0.size.equalTo(moderateScale(number: 60))
        }
        
        self.snackImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 60))
        }
        
        self.imageStackView.snp.makeConstraints {
            $0.leading.equalTo(self.rankLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 13))
        }

        self.nameStackView.snp.makeConstraints {
            $0.leading.equalTo(self.imageStackView.snp.trailing).offset(moderateScale(number: 8))
            $0.top.equalToSuperview().offset(moderateScale(number: 15))
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 15))
        }
    }
}
