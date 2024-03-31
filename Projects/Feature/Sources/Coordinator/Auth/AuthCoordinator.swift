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
        }
    }
    
    private func startProfileInputFlow(_ scene: ProfileInputScene, userData: [String: Any]?) {
        switch scene {
//        case .nickName:
//            moveToNickNameScene(userData)
        case .selectDrink:
            moveToSelectDrinkScene(userData)
        case .selectSnack:
            moveToSelectSnackScene(userData)
        }
    }
}

extension AuthCoordinator {
//    private func moveToNickNameScene(_ userData: [String: Any]?) {
//        
//    }
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
}
