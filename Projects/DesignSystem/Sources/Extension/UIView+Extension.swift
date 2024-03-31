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
    
    func setShadow(color: UIColor, opacity: Float = 1.0, offSet: CGSize = .zero, radius: CGFloat) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius
    }
    
    func setGradient(startColor: UIColor, endColor: UIColor, location: [NSNumber] = [0.0, 1.0]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = location
        gradientLayer.frame = bounds
                
        layer.addSublayer(gradientLayer)
    }
}
