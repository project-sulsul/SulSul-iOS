//
//  RankingCombinationCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

final class RankingCombinationCell: BaseCollectionViewCell<RankingItem> {
    
    static let reuseIdentifier = "RankingCombinationCell"
    
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
        $0.layer.cornerRadius = CGFloat(30)
        $0.layer.masksToBounds = true
    }
    
    private lazy var snackImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = CGFloat(30)
        $0.layer.masksToBounds = true
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
        $0.addArrangedSubviews([drinkImageView, snackImageView])
        $0.bringSubviewToFront(drinkImageView)
    }
    
    private lazy var nameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.addArrangedSubviews([drinkNameLabel, snackNameLabel])
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
        drinkNameLabel.text = nil
        snackNameLabel.text = nil
        drinkImageView.image = nil
        snackImageView.image = nil
    }
    
    override func bind(_ model: RankingItem) {
        super.bind(model)
        
        configure(model)
    }
}

// MARK: - Custom Method

extension RankingCombinationCell {
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([
            rankLabel,
            variationLabel,
            variationImageView,
            imageStackView,
            nameStackView
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
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 13))
        }
        variationLabel.snp.makeConstraints {
            $0.leading.equalTo(variationImageView.snp.trailing)
            $0.top.equalTo(rankLabel.snp.bottom)
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 13))
        }
        drinkImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 60))
        }
        snackImageView.snp.makeConstraints {
            $0.size.equalTo(drinkImageView)
        }
        imageStackView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.top.equalTo(rankLabel)
            $0.bottom.equalTo(variationLabel)
        }
        drinkNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 10))
        }
        snackNameLabel.snp.makeConstraints {
            $0.leading.equalTo(drinkNameLabel)
        }
        nameStackView.snp.makeConstraints {
            $0.leading.equalTo(imageStackView.snp.trailing).offset(moderateScale(number: 8))
            $0.top.equalToSuperview().offset(moderateScale(number: 15))
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 15))
        }
    }
    
    private func configure(_ model: RankingItem) {
        if let rank = model.rank {
            rankLabel.text = String(rank)
        } else {
            print("Rank value is not available.")
        }
        
        if let pairings = model.pairings, pairings.count >= 2 {
            if let drinkName = pairings[0].name {
                drinkNameLabel.text = drinkName
            }
            
            if let snackName = pairings[1].name {
                snackNameLabel.text = "& " + snackName
            }
            
            if let drinkImageURLString = pairings[0].image, let drinkImageURL = URL(string: drinkImageURLString) {
                drinkImageView.loadImage(drinkImageURL)
            } else {
                print("Drink Image URL is not available.")
                drinkImageView.image = UIImage(systemName: "circle.fill")
            }
            
            if let snackImageURLString = pairings[1].image, let snackImageURL = URL(string: snackImageURLString) {
                snackImageView.loadImage(snackImageURL)
            } else {
                print("Snack Image URL is not available.")
                snackImageView.image = UIImage(systemName: "circle.fill")
            }
        } else {
            print("Pairings data is not available")
        }
    }
}
