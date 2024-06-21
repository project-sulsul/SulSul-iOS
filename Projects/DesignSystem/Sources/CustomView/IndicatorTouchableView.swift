//
//  IndicatorTouchableView.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/11/21.
//

import UIKit

public final class IndicatorTouchableView: TouchableView {
    private let indicator = UIActivityIndicatorView()
    private lazy var alwaysClickable: Bool = false
    private let label = UILabel()
    
    public var text: String? {
        didSet {
            label.text = text
        }
    }
    
    public var font: UIFont? {
        didSet {
            label.font = font
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        attribute()
    }
    
    public convenience init(alwaysClickable: Bool = false) {
        self.init(frame: .zero)
        
        self.alwaysClickable = alwaysClickable
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        indicator.startAnimating()
        label.isHidden = true
    }
    
    func stopAnimating() {
        indicator.stopAnimating()
        label.isHidden = false
    }
    
    private func attribute() {
        label.textAlignment = .center
        label.backgroundColor = .clear
        indicator.color = .white
    }
    
    private func layout() {
        addSubviews([indicator, label])
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public func setClickable(_ canClick: Bool) {
        if canClick {
            isUserInteractionEnabled = alwaysClickable || true
            backgroundColor = DesignSystemAsset.main.color
            textColor = DesignSystemAsset.gray050.color
            
        } else {
            isUserInteractionEnabled = false
            backgroundColor = DesignSystemAsset.gray200.color
            textColor = DesignSystemAsset.gray700.color
        }
    }
}
