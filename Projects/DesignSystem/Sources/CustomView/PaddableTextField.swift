//
//  PaddableTextField.swift
//  DesignSystem
//
//  Created by Yujin Kim on 2024-03-13.
//

import UIKit

public final class PaddableTextField: UITextField {
    fileprivate var edgeInsets: UIEdgeInsets
    
    required public init(to insetAll: CGFloat) {
        self.edgeInsets = UIEdgeInsets(top: insetAll, left: insetAll, bottom: insetAll, right: insetAll)
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
    
    public override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        
        let width = contentSize.width + edgeInsets.left + edgeInsets.right
        let height = contentSize.height + edgeInsets.top + edgeInsets.bottom
        
        return CGSize(width: width, height: height)
    }
}
