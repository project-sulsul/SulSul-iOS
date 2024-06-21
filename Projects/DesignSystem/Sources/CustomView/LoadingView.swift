//
//  LoadingView.swift
//  DesignSystem
//
//  Created by 이범준 on 5/18/24.
//

import UIKit
import Then
import SnapKit
import Lottie

final class LoadingView: UIView {
    private lazy var backgroundView = UIView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private lazy var animationView = LottieAnimationView(name: "loading").then {
        $0.loopMode = .loop
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        addViews()
        makeConstraints()
        
        animationView.play()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(animationView)
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 80))
        }
    }
}
