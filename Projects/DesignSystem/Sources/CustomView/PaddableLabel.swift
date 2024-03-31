//
//  PaddableLabel.swift
//  DesignSystem
//
//  Created by Yujin Kim on 2024-03-03.
//

import UIKit

public final class PaddableLabel: UILabel {
    fileprivate var topInset: CGFloat
    fileprivate var leftInset: CGFloat
    fileprivate var bottomInset: CGFloat
    fileprivate var rightInset: CGFloat
    
    required public init(edgeInsets top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        self.topInset = top
        self.leftInset = left
        self.bottomInset = bottom
        self.rightInset = right
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
    
    override public func drawText(in rect: CGRect) {
        let edgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        
        super.drawText(in: rect.inset(by: edgeInsets))
    }
}
