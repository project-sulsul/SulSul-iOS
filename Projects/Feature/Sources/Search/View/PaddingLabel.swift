//
//  PaddingLabel.swift
//  Feature
//
//  Created by 김유진 on 3/20/24.
//

import UIKit
import DesignSystem

final class PaddingLabel: UIStackView {
    
    private lazy var padding: UIEdgeInsets = .init(top: moderateScale(number: 4),
                                                   left: moderateScale(number: 8),
                                                   bottom: moderateScale(number: 4),
                                                   right: moderateScale(number: 8))
    
    private lazy var label = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    convenience init(text: String = "", padding: UIEdgeInsets) {
        
        self.init(frame: .zero)
        self.padding = padding
        
        if text != "" {
            setText("asdfasdf")
            self.addArrangedSubview(label)
            self.isLayoutMarginsRelativeArrangement = true
            self.layoutMargins = padding
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.setLineHeight(18, text: text, font: Font.regular(size: 12))
        self.addArrangedSubview(label)
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = padding
    }
}
