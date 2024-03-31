//
//  KeyboardNumberCell.swift
//  ut-global-ios
//
//  Created by 이범준 on 2023/11/14.
//

import UIKit
import DesignSystem

final class DrinkCell: BaseCollectionViewCell<SnackModel> {
    
    static let reuseIdentifer = "DrinkCell"

    private lazy var containerView = UIView().then({
        $0.layer.borderColor = DesignSystemAsset.gray500.color.cgColor
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
    })
    
    private lazy var drinkImageView = UIImageView().then({
        $0.image = UIImage(systemName: "circle.fill")
    })
    private lazy var drinkNameLabel = UILabel().then({
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray500.color
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([drinkImageView,
                                   drinkNameLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { constraints in
            constraints.edges.equalToSuperview()
        }
        drinkImageView.snp.makeConstraints { constraints in
            constraints.top.equalToSuperview().offset(moderateScale(number: 15.39))
            constraints.centerX.equalToSuperview()
            constraints.size.equalTo(moderateScale(number: 80))
        }
        drinkNameLabel.snp.makeConstraints { constraints in
            constraints.centerX.equalToSuperview()
            constraints.bottom.equalToSuperview().offset(moderateScale(number: -15.39))
        }
    }
    
    override func bind(_ model: SnackModel) {
        super.bind(model)
        if let imageUrl = URL(string: model.image) {
            drinkImageView.kf.setImage(with: imageUrl)
        } else {
            drinkImageView.image = UIImage(systemName: "circle.fill")
        }
        drinkNameLabel.text = model.name
    }
    
    func setSelectColor(_ isSelect: Bool) {
        containerView.backgroundColor = isSelect ? DesignSystemAsset.main.color : .clear
        drinkNameLabel.textColor = isSelect ? DesignSystemAsset.black.color : DesignSystemAsset.gray500.color
    }

}
