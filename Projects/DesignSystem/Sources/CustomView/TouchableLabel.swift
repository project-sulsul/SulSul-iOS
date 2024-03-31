//
//  TouchableLabel.swift
//  DesignSystem
//
//  Created by 이범준 on 12/9/23.
//

import UIKit

public final class TouchableLabel: UILabel {
    var isEffectSet: Bool = true
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
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
