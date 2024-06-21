//
//  LogoImageView.swift
//  DesignSystem
//
//  Created by Yujin Kim on 2024-05-14.
//

import UIKit

public final class LogoImageView: UIImageView {
    // MARK: - Initializer
    //
    public init() {
        super.init(frame: .zero)
        
        self.image = UIImage(named: "sulsul")
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
