//
//  Coordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

public protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var rootViewController: UIViewController { get set }
    
    func start() -> UIViewController
    func moveTo(appFlow: Flow, userData: [String: Any]?)
}

extension Coordinator {
    var rootNavigationController: UINavigationController? {
        (rootViewController as? UINavigationController)
    }
}

protocol Coordinated {
    var coordinator: Coordinator? { get }
}

public protocol Flow {}

extension Flow {
    var appFlow: AppFlow? {
        (self as? AppFlow)
    }
    
    var tabBarFlow: TabBarFlow? {
        (self as? TabBarFlow)
    }
}

enum AppFlow: Flow {
    case tabBar(TabBarFlow)
}

enum TabBarFlow: Flow {
    case auth(AuthFlow)
    case common(CommonScene)
    case home(HomeScene)
    case benefit(BenefitScene)
    case transfer(TransferScene)
    case transferHistory(TransferHistoryScene)
    case more(ProfileScene)
}

enum AuthFlow: Flow {
//    case login(LoginScene)
//    case signUp(SignUpScene)
//    case findEmail(FindEmailScene)
//    case findPassword(FindPasswordScene)
    case profileInput(ProfileInputScene)
//    case simplePasswordSetting
//    case simplePasswordLogin
}

enum CommonScene {
    case web
}

enum LoginScene {
    case main
    case loginError
}

enum SignUpScene {
    case intro
    case email
    case emailAuthorization
    case password
    case referralCode
    case complete
    case signUpError
}

enum FindEmailScene {
    case countryBottomSheet
    case sms
    case smsAuthorization
    case complete
}

enum FindPasswordScene {
    case intro
    case email
    case sms
    case authorization
    case newPassword
    case complete
}

enum HomeScene {
    case main
}

enum BenefitScene {
    case main
}

enum TransferScene {
    case main
}

enum TransferHistoryScene {
    case main
}

enum ProfileInputScene {
    case selectDrink
    case selectSnack
}

// MARK: - 마이페이지
enum ProfileScene {
    case main
    case profileSetting
    case profileEdit
}

enum ProfileManagementScene {
    case profileMain
    case managementProfile
    case managementAccount
    case managementPhoneNumber
    case managementAuthentication
    case editProfile
}
