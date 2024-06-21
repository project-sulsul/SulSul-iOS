//
//  HomeViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit
import DesignSystem
import Service

final class HomeViewController: BaseViewController {
    // MARK: - 테스트용 jsonDecoder, userid 삭제 필요
    private lazy var jsonDecoder = JSONDecoder()
    private let userId = UserDefaultsUtil.shared.getInstallationId()
    
    var coordinator: HomeBaseCoordinator?
    
    private lazy var loginButton = TouchableView().then({
        $0.backgroundColor = .red
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 테스트용 추후 삭제 필요
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(userId)") { [weak self] result in
            switch result {
            case .success(let response):
                if let userData = try? self?.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    print(">>>>>>>")
                    print(userData)
                } else {
                    print("디코딩 모델 에러 9")
                }
            case .failure(let error):
                print(error)
            }
        }
        
        view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
        
        if (KeychainStore.shared.read(label: "accessToken") != nil) {
            loginButton.isHidden = true
        } else {
            loginButton.isHidden = false
        }
    }
    
    override func addViews() {
        view.addSubview(loginButton)
    }
    
    override func makeConstraints() {
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 50))
        }
    }
    
    override func setupIfNeeded() {
        loginButton.setOpaqueTapGestureRecognizer { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.auth(.login), userData: nil)
        }
    }
}
