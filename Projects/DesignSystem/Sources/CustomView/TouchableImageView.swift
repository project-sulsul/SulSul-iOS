//
//  TouchableImageView.swift
//  DesignSystem
//
//  Created by 이범준 on 12/31/23.
//

import UIKit

public final class TouchableImageView: UIImageView {
    public var isEffectSet: Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        
        /// x: 10, y: 15 만큼 영역 증가
        /// dx: x축이 dx만큼 증가 (음수여야 증가)
        let touchArea = bounds.insetBy(dx: -10, dy: -10)
        return touchArea.contains(point)
    }
    
    public func setOpaqueTapGestureRecognizer(setEffect: Bool? = true, onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(blur(gesture:)))
        gesture.onTapped = onTapped
        if let setEffect = setEffect { isEffectSet = setEffect }
        addGestureRecognizer(gesture)
    }
    
    @objc private func blur(gesture: TapGestureRecognizer) {
        if gesture.onTapped != nil, alpha == 1 {
            if isEffectSet {
                alpha = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in self?.alpha = 1.0 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { gesture.onTapped!() }
        }
    }
}
