//
//  NotFoundDetailFeedView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-31.
//

import UIKit
import DesignSystem

final class NotFoundDetailFeedView: UIView {
    private lazy var notFoundLabel = UILabel().then {
        $0.setLineHeight(24, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.text = "피드 내용을 찾을 수 없어요."
        $0.textColor = DesignSystemAsset.gray400.color
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(notFoundLabel)
    }
    
    private func makeConstraints() {
        notFoundLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
