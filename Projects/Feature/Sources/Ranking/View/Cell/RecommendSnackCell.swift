//
//  RecommendSnackCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-04.
//

import UIKit
import DesignSystem

final class RecommendSnackCell: BaseCollectionViewCell<RankingItem> {
    static let reuseIdentifier = "RecommendSnackCell"
    
    private lazy var containerView = UIView().then {
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    private lazy var rankLabel = UILabel().then {
        $0.setLineHeight(36, font: Font.bold(size: 24))
        $0.textAlignment = .center
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.text = "1"
    }
    
    private lazy var snackNameLabel = UILabel().then {
        $0.setLineHeight(36, font: Font.bold(size: 24))
        $0.textAlignment = .center
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.text = "나초"
    }
    
    private lazy var scoreStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = CGFloat(0)
    }
    
    private lazy var scoreImageView = UIImageView().then {
        $0.image = UIImage(named: "hand_clapping")
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.setLineHeight(18, font: Font.bold(size: 12))
        $0.textAlignment = .center
        $0.font = Font.bold(size: 12)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.text = "0.0"
    }
    
    private lazy var firstSnackImageView = UIImageView().then {
        $0.backgroundColor = .red
    }
    
    private lazy var secondSnackImageView = UIImageView().then {
        $0.backgroundColor = .blue
    }
    
    private lazy var thirdSnackImageView = UIImageView().then {
        $0.backgroundColor = .yellow
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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        rankLabel.text = nil
//        snackNameLabel.text = nil
//        firstSnackImageView.image = nil
//        secondSnackImageView.image = nil
//        thirdSnackImageView.image = nil
//    }
    
    override func bind(_ model: RankingItem) {
        super.bind(model)
        
        configure(model)
    }
    
    // MARK: - Custom Method
    
    private func addViews() {
        containerView.addSubviews([
            rankLabel,
            snackNameLabel,
            scoreImageView,
            scoreLabel,
            firstSnackImageView,
            secondSnackImageView,
            thirdSnackImageView
        ])
        
        addSubview(containerView)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rankLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(moderateScale(number: 10))
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
        }
        snackNameLabel.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.top.equalTo(rankLabel)
        }
        scoreLabel.snp.makeConstraints {
            $0.trailing.equalTo(containerView.snp.trailing).offset(moderateScale(number: -10))
            $0.top.equalToSuperview().offset(moderateScale(number: 25))
        }
        scoreImageView.snp.makeConstraints {
            $0.trailing.equalTo(scoreLabel.snp.leading).offset(moderateScale(number: -4))
            $0.top.equalToSuperview().offset(moderateScale(number: 25))
            $0.size.equalTo(moderateScale(number: 16))
        }
        firstSnackImageView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel)
            $0.top.equalTo(rankLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.size.equalTo(moderateScale(number: 232))
        }
        secondSnackImageView.snp.makeConstraints {
            $0.leading.equalTo(firstSnackImageView.snp.trailing).offset(moderateScale(number: 9))
            $0.top.equalTo(rankLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.size.equalTo(moderateScale(number: 112))
        }
        thirdSnackImageView.snp.makeConstraints {
            $0.leading.equalTo(secondSnackImageView)
            $0.top.equalTo(secondSnackImageView.snp.bottom).offset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 112))
        }
    }
    
    private func configure(_ model: RankingItem) {
//        if let rank = model.rank {
//            rankLabel.text = String(rank)
//        } else {
//            print("Rank value is not available.")
//        }
//        
//        if let imageURLString = model.drink?.image,
//           let imageURL = URL(string: imageURLString) {
//            drinkImageView.loadImage(imageURL)
//        } else {
//            print("Image URL is not available.")
//            drinkImageView.image = UIImage()
//        }
//        
//        if let subtype = model.drink?.subtype {
//            subtypeLabel.text = String(subtype)
//        } else {
//            print("Subtype value is not available.")
//        }
//        
//        if let drinkName = model.drink?.name {
//            drinkNameLabel.text = drinkName
//        } else {
//            print("Drink name is not available.")
//        }
    }
}
