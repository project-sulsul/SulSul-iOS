//
//  CarouselIndicatorView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-01.
//

import UIKit
import SnapKit
import DesignSystem

final class CarouselIndicatorView: UIView {
    // MARK: - Properties
    //
    private var leadingConstraint: Constraint?
    private var duration: TimeInterval = 0.3
    
    var widthRatio: Double? {
        didSet {
            guard let widthRatio = self.widthRatio else { return }
            
            self.tintView.snp.remakeConstraints {
                $0.leading.greaterThanOrEqualToSuperview()
                $0.trailing.lessThanOrEqualToSuperview()
                $0.top.bottom.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(widthRatio)
                self.leadingConstraint = $0.left.equalToSuperview().priority(999).constraint
            }
        }
    }
    
    var leadingOffsetRatio: Double? {
        didSet {
            guard let leadingOffsetRatio = self.leadingOffsetRatio else { return }
              
            self.leadingConstraint?.update(inset: leadingOffsetRatio * self.bounds.width)
        }
    }
    
    // MARK: - Components
    //
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray300.color
    }
    
    private lazy var tintView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.main.color
    }
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method
//
extension CarouselIndicatorView {
    func updateLeadingOffsetRatio(_ ratio: Double) {
        UIView.animate(withDuration: self.duration) {
            self.leadingConstraint?.update(inset: ratio * self.bounds.width)
            self.layoutIfNeeded()
        }
    }
    
    private func addViews() {
        self.backgroundView.addSubview(self.tintView)
        self.addSubview(backgroundView)
    }
    
    private func makeConstraints() {
        self.backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.tintView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.0/5.0)
            self.leadingConstraint = $0.left.equalToSuperview().priority(999).constraint
        }
    }
}
