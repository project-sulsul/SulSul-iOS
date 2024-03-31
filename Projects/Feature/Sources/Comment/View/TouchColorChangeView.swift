//
//  TouchColorChangeView.swift
//  Feature
//
//  Created by 김유진 on 3/14/24.
//

import UIKit
import DesignSystem

final class TouchColorChangeView: UIView {
    private lazy var onTapped = {}
    private lazy var tapColor: UIColor? = DesignSystemAsset.gray100.color
    
    convenience init(bgColor: UIColor?, tapColor: UIColor?) {
        self.init()
        
        self.tapColor = tapColor
        backgroundColor = bgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = DesignSystemAsset.gray050.color
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func onTapped(action: @escaping () -> Void) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.onTapped = action
        addGestureRecognizer(gesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.backgroundColor = self?.tapColor
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.backgroundColor = DesignSystemAsset.gray050.color
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.backgroundColor = DesignSystemAsset.gray050.color
        }
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        onTapped()
    }
}
