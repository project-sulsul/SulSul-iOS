//
//  TouchableView.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

public final class TouchableView: UIView {
    fileprivate var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    convenience init(_ vibrate: Bool = false) {
        self.init()
        self.impactFeedbackGenerator = vibrate ? UIImpactFeedbackGenerator(style: .light) : nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)

        /// x: 10, y: 15 만큼 영역 증가
        /// dx: x축이 dx만큼 증가 (음수여야 증가)
        let touchArea = bounds.insetBy(dx: -10, dy: -15)
        return touchArea.contains(point)
    }
    
    func setOpaqueTapGesturePositionRecognizer(onTapped: @escaping (CGPoint) -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(effect(gesture:)))
        gesture.opTappedPosition = onTapped
        addGestureRecognizer(gesture)
    }
    
    public func setOpaqueTapGestureRecognizer(onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(effect(gesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    func addSubView(views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
    
    @objc private func effect(gesture: TapGestureRecognizer) {
        impactFeedbackGenerator?.impactOccurred()
        if gesture.onTapped != nil, alpha == 1 {
            alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {  gesture.onTapped?() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in self?.alpha = 1.0 }
        } else if gesture.opTappedPosition != nil, alpha == 1 {
            alpha = 0.5
            let position = gesture.location(in: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { gesture.opTappedPosition?(position) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in self?.alpha = 1.0 }
        }
    }
}
