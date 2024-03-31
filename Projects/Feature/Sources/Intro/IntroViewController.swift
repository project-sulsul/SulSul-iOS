//
//  IntroViewController.swift
//  Feature
//
//  Created by 이범준 on 2024/01/04.
//

import UIKit
import Then
import SnapKit
import DesignSystem

final class IntroViewController: BaseViewController, MainBaseCoordinated {
    var coordinator: MainBaseCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.coordinator?.moveTo(appFlow: AppFlow.tabBar(.auth(.profileInput(.selectDrink))), userData: nil)
        }
    }
    
    private lazy var startButton = TouchableView().then {
        $0.layer.borderColor = UIColor.purple.cgColor
        $0.layer.borderWidth = 1
    }
    
    override func addViews() {
        view.addSubview(startButton)
    }
    
    override func makeConstraints() {
        startButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 100))
        }
    }
}
