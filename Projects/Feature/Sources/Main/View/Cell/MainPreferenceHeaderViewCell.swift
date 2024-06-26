//
//  MainPreferenceHeaderViewCell.swift
//  Feature
//
//  Created by 이범준 on 3/1/24.
//

import UIKit
import DesignSystem

final class MainPreferenceHeaderViewCell: UICollectionViewCell {
    
    lazy var containerView = TouchableView().then({
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.backgroundColor = .clear
    })
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "test"
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.bold(size: 16)
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
        containerView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bind(_ model: SelectableAlcohol) {
        titleLabel.text = model.title
        if model.isSelected {
            containerView.backgroundColor = DesignSystemAsset.main.color
            titleLabel.textColor = DesignSystemAsset.gray050.color
        } else {
            containerView.backgroundColor = .clear
            titleLabel.textColor = DesignSystemAsset.gray400.color
        }
    }
}
    
struct SelectableAlcohol {
    let title: String
    var isSelected: Bool = false
}
