//
//  UserTagCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-19.
//

import UIKit
import DesignSystem

final class UserTagCell: UICollectionViewCell {
    static let reuseIdentifier: String = "UserTagCell"
    
    // MARK: - Components
    //
    lazy var tagLabel = UILabel().then {
        $0.setLineHeight(18, font: Font.regular(size: 12))
        $0.font = Font.regular(size: 12)
        $0.textColor = DesignSystemAsset.gray300.color
    }
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = DesignSystemAsset.gray050.color
        self.contentView.layer.cornerRadius = CGFloat(8)
        self.contentView.layer.masksToBounds = true
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Method

extension UserTagCell {
    public func bind(withUserTag text: String) {
        self.tagLabel.text = text
    }
    
    private func addViews() {
        self.contentView.addSubview(tagLabel)
    }
    
    private func makeConstraints() {
        self.tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
