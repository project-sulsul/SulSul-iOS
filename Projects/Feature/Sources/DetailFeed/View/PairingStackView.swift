//
//  PairingStackView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-22.
//

import UIKit
import DesignSystem

final class PairingStackView: UIView {
    private lazy var stackView = UIStackView().then {
        $0.spacing = CGFloat(4)
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
    }
    
    private lazy var drinkLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18, font: Font.semiBold(size: 12))
        $0.font = Font.semiBold(size: 12)
        $0.text = "처음처럼"
        $0.textColor = DesignSystemAsset.gray400.color
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = CGFloat(4)
        $0.layer.masksToBounds = true
    }
    
    private lazy var anpersandLabel = UILabel().then {
        $0.setLineHeight(18, font: Font.semiBold(size: 12))
        $0.font = Font.semiBold(size: 12)
        $0.text = "&"
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var snackLabel = PaddableLabel(edgeInsets: 1, 4, 1, 4).then {
        $0.setLineHeight(18, font: Font.semiBold(size: 12))
        $0.font = Font.semiBold(size: 12)
        $0.text = "삼겹살"
        $0.textColor = DesignSystemAsset.gray400.color
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = CGFloat(4)
        $0.layer.masksToBounds = true
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
    
    private func addViews() {
        self.stackView.addArrangedSubviews([
            drinkLabel,
            anpersandLabel,
            snackLabel
        ])
        
        self.addSubview(stackView)
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind(_ model: DetailFeed.PairingStack) {
        drinkLabel.text = model.alcohol.name
        snackLabel.text = model.snack.name
    }
}
