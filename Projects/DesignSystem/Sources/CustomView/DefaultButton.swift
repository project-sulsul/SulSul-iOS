//
//  DefaultButton.swift
//  DesignSystem
//
//  Created by 김유진 on 2/26/24.
//

import UIKit

public class DefaultButton: UIView {
    private lazy var titleLabel = UILabel().then {
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray700.color
    }
    
    public convenience init(title: String) {
        self.init(frame: .zero)
        
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = moderateScale(number: 12)
        backgroundColor = DesignSystemAsset.gray200.color
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setClickable(_ canClick: Bool) {
        if canClick {
            isUserInteractionEnabled = false
            backgroundColor = DesignSystemAsset.main.color
            titleLabel.textColor = DesignSystemAsset.gray050.color
            
        } else {
            isUserInteractionEnabled = true
            backgroundColor = DesignSystemAsset.gray200.color
            titleLabel.textColor = DesignSystemAsset.gray700.color
        }
    }
}