//
//  test.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import UIKit
import DesignSystem
import Then
import SnapKit

public final class SplashViewController: BaseViewController {
    var coordinator: MainBaseCoordinator?
    
    private lazy var testTouchableView: TouchableView = TouchableView().then({
        $0.backgroundColor = .blue
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func addViews() {
        view.addSubview(testTouchableView)
    }
    public override func makeConstraints() {
        testTouchableView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 50))
        }
    }
    public override func setupIfNeeded() {
        testTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
//            self?.coordinator?.moveTo(appFlow: AppFlow.intro, userData: nil)
            
            self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.home(.main)), userData: nil)
        }
    }
}
