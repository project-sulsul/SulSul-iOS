//
//  AuthCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2024/01/04.
//

import UIKit

final class AuthCoordinator: AuthBaseCoordinator {
    
    var parentCoordinator: Coordinator?
    var currentFlowManager: CurrentFlowManager?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        return UIViewController()
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .auth(let authFlow):
            startAuthFlow(authFlow, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    private func startAuthFlow(_ flow: AuthFlow, userData: [String: Any]?) {
        switch flow {
        case .profileInput(let profileInputScene):
            startProfileInputFlow(profileInputScene, userData: userData)
        case .login:
            let loginVC = AuthViewController()
            loginVC.coordinator = self
            currentNavigationViewController?.interactivePopGestureRecognizer?.isEnabled = true
            currentNavigationViewController?.pushViewController(loginVC, animated: true)
        }
    }
    
    private func startProfileInputFlow(_ scene: ProfileInputScene, userData: [String: Any]?) {
        switch scene {
        case .setUserName:
            moveToNickNameScene(userData)
        case .selectDrink:
            moveToSelectDrinkScene(userData)
        case .selectSnack:
            moveToSelectSnackScene(userData)
        case .selectComplete:
            moveToSelectCompleteScene(userData)
        }
    }
}

extension AuthCoordinator {
    private func moveToNickNameScene(_ userData: [String: Any]?) {
        let viewModel = SelectUserNameViewModel()
        let setUserNameVC = SetUserNameViewController(viewModel: viewModel)
        setUserNameVC.coordinator = self
        currentNavigationViewController?.pushViewController(setUserNameVC, animated: false)
    }
    private func moveToSelectDrinkScene(_ userData: [String: Any]?) {
        let viewModel = SelectDrinkViewModel()
        let selectDrinkVC = SelectDrinkViewController(viewModel: viewModel)
        selectDrinkVC.coordinator = self
        currentNavigationViewController?.pushViewController(selectDrinkVC, animated: false)
    }
    private func moveToSelectSnackScene(_ userData: [String: Any]?) {
        let viewModel = SelectSnackViewModel()
        let selectSnackVC = SelectSnackViewController(viewModel: viewModel)
        selectSnackVC.coordinator = self
        currentNavigationViewController?.pushViewController(selectSnackVC, animated: true)
    }
    private func moveToSelectCompleteScene(_ userData: [String: Any]?) {
        let selectCompleteVC = CompleteViewController()
        selectCompleteVC.coordinator = self
        currentNavigationViewController?.pushViewController(selectCompleteVC, animated: true)
    }
}
