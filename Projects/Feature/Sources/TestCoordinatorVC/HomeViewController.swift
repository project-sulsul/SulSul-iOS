//
//  HomeViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit
import DesignSystem

final class HomeViewController: BaseViewController {
    var coordinator: HomeBaseCoordinator?
    
    private lazy var testTouchableView: TouchableView = TouchableView().then({
        $0.backgroundColor = .blue
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
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
            print(self?.coordinator)
            self?.coordinator?.moveTo(appFlow: AppFlow.intro, userData: nil)
        }
    }
}
