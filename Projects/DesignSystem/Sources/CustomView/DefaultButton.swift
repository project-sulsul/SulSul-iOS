//
//  DefaultButton.swift
//  DesignSystem
//
//  Created by 김유진 on 2/26/24.
//

import UIKit

public class DefaultButton: UIView {
    private lazy var alwaysClickable: Bool = false
    
    private lazy var titleLabel = UILabel().then {
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray700.color
    }
    
    public convenience init(title: String, alwaysClickable: Bool = false) {
        self.init(frame: .zero)
        
        self.alwaysClickable = alwaysClickable
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
    
    public func title(_ text: String) {
        titleLabel.text = text
    }
    
    public func textColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    
    public func setClickable(_ canClick: Bool) {
        if canClick {
            isUserInteractionEnabled = alwaysClickable || true
            backgroundColor = DesignSystemAsset.main.color
            titleLabel.textColor = DesignSystemAsset.gray050.color
            
        } else {
            isUserInteractionEnabled = false
            backgroundColor = DesignSystemAsset.gray200.color
            titleLabel.textColor = DesignSystemAsset.gray700.color
        }
    }
}
