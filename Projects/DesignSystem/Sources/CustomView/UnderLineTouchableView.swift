//
//  UnderLineTouchableView.swift
//  DesignSystem
//
//  Created by 이범준 on 2/9/24.
//

import UIKit

public final class UnderlineTouchableView: TouchableView {
    
    public init(_ title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = UILabel().then({
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.main.color
        $0.textAlignment = .center
    })
    
    private lazy var underlineView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.main.color
    })
    
    private func addViews() {
        addSubviews([titleLabel,
                     underlineView])
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 10))
            $0.leading.trailing.equalToSuperview()
        }
        underlineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(moderateScale(number: -2))
            $0.height.equalTo(moderateScale(number: 2))
        }
    }
    
    public func updateView(_ isSelected: Bool) {
        titleLabel.textColor = isSelected ? DesignSystemAsset.main.color : DesignSystemAsset.gray300.color
        underlineView.backgroundColor = isSelected ? DesignSystemAsset.main.color : DesignSystemAsset.gray300.color
    }
}
