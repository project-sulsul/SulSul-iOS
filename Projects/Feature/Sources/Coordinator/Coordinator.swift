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
    case intro
    case tabBar(TabBarFlow)
}

enum TabBarFlow: Flow {
    case auth(AuthFlow)
//    case common
    case home(HomeScene)
    case benefit
    case transfer
    case transferHistory
    case more(MoreFlow)
}

enum AuthFlow: Flow {
//    case login(LoginScene)
//    case signUp(SignUpScene)
//    case findEmail(FindEmailScene)
//    case findPassword(FindPasswordScene)
    case profileInput(ProfileInputScene)
}

enum MoreFlow: Flow {
    case profile(ProfileManagementScene)
}

enum LoginScene {
    case main
}

enum SignUpScene {
    case intro
    case email
    case emailAuthorization
    case password
    case referralCode
    case complete
    case bottomSheet
}

enum FindEmailScene {
    case sms
    case smsAuthorization
    case complete
}

enum FindPasswordScene {
    case intro
    case email
    case sms
    case smsAuthorization
    case newPassword
    case complete
}

enum HomeScene {
    case main
}

enum ProfileInputScene {
    case nickName
    case selectDrink
    case selectSnack
}

enum ProfileManagementScene {
    case profileMain
    case managementProfile
    case managementAccount
    case managementPhoneNumber
    case managementAuthentication
    case editProfile
}
