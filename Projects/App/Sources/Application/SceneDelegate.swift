//
//  Temp.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import KakaoSDKAuth
import Feature
import Service
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainBaseCoordinator?
    var currentScene: UIScene?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        currentScene = scene
        mainCoordinator = MainCoordinator()
        setRootViewController(mainCoordinator!.start())
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        guard let scene = (currentScene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}


//        // 키체인 테스트
//        if KeychainStore.shared.read(label: "accessToken") != nil {
//            let viewController = SetUserNameViewController()
//            window?.rootViewController = viewController
//        } else {
//            let viewController = SignInViewController()SettingViewController
//            window?.rootViewController = viewController
//        }
        mainCoordinator = MainCoordinator()
        window?.rootViewController = mainCoordinator?.start()
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
