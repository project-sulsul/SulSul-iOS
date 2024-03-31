//
//  UIView+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/08/24.
//

import UIKit

public extension UIView {
    typealias GestureHandler = (() -> Void)?

    private struct GestureAssociatedKey {
        fileprivate static var tapGestureKey = "associated_TapGestureKey"
    }
    
    private var tapGestureRecognizerHandler: GestureHandler? {
        get {
            return objc_getAssociatedObject(self,
                                            &GestureAssociatedKey.tapGestureKey) as? GestureHandler
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &GestureAssociatedKey.tapGestureKey,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    
    func onTapped(_ handler: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerHandler = handler
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerHandler {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                action?()
            }
        }
    }
}
