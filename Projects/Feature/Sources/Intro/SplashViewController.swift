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
import Service

public final class SplashViewController: BaseViewController {
    var coordinator: MainBaseCoordinator?
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "여기 무슨 문구들어갈까\n어쩌구 저쩌구\n술술"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 32)
        $0.numberOfLines = 0
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if KeychainStore.shared.read(label: "accessToken") != nil {
                print("로그인되어 있음")
            } else {
                print("로그인 안되어있음")
            }
            self.coordinator?.moveTo(appFlow: AppFlow.tabBar(.home(.main)), userData: nil)
        }
    }
    public override func addViews() {
        view.addSubviews([titleLabel])
    }
    
    public override func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(moderateScale(number: 52))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
    }
   
}
