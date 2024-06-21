//
//  SearchResultCell.swift
//  Feature
//
//  Created by 김유진 on 3/19/24.
//

import UIKit
import DesignSystem

final class SearchResultCell: UITableViewCell {
    static let id = "SearchResultCell"
    
    private lazy var pairingImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var categoryNameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 2)
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 20)
    }

    private lazy var categoryView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray700.color
        $0.font = Font.regular(size: 10)
    }
    
    private lazy var nextButton = UIImageView(image: UIImage(named: "common_rightArrow")?.withTintColor(DesignSystemAsset.gray700.color))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = DesignSystemAsset.black.color
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ model: Pairing) {
        nameLabel.text = model.name
        
        if let url = URL(string: model.image ?? "") {
            pairingImageView.kf.setImage(with: url)
        }
    }
}

extension SearchResultCell {
    private func addViews() {
        addSubviews([
            pairingImageView,
            categoryNameStackView,
            nextButton
        ])
        
        categoryNameStackView.addArrangedSubviews([
            categoryView,
            nameLabel
        ])
        
        categoryView.addSubview(categoryLabel)
    }
    
    private func makeConstraints() {
        pairingImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 30))
            $0.size.equalTo(moderateScale(number: 70))
            $0.centerY.equalToSuperview()
        }
        
        categoryNameStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pairingImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.trailing.equalTo(nextButton.snp.leading).offset(moderateScale(number: -4))
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 2))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 30))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
