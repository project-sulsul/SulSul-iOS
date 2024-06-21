//
//  CommentFooterView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-21.
//

import UIKit
import DesignSystem

final class CommentFooterView: UICollectionReusableView {
    static let reuseIdentifier: String = "CommentFooterView"
    
    lazy var touchableLabel = TouchableLabel().then {
        $0.setLineHeight(28, font: Font.bold(size: 18))
        $0.font = Font.bold(size: 18)
        $0.text = "댓글 더보기"
        $0.textColor = DesignSystemAsset.gray500.color
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
        self.addSubview(touchableLabel)
    }
    
    private func makeConstraints() {
        touchableLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
