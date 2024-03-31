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
    case ranking(RankingScene)
    case transfer(TransferScene)
    case transferHistory(TransferHistoryScene)
    case more(ProfileScene)
}

enum AuthFlow: Flow {
    case login
    case profileInput(ProfileInputScene)
}

enum CommonScene {
    case web
    case selectPhoto
    case writePostText
    case writeContent
    case reportContent
    case search
    case comment
    case feedDetail
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

// MARK: - 랭킹페이지

enum RankingScene {
    case main
    case search
    case alarm
    case detailDrink
    case detailCombination
}

enum TransferScene {
    case main
}

enum TransferHistoryScene {
    case main
}

enum ProfileInputScene {
    case setUserName
    case selectDrink
    case selectSnack
    case selectComplete
}

// MARK: - 마이페이지
enum ProfileScene {
    case main
    case profileSetting
    case profileEdit
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
