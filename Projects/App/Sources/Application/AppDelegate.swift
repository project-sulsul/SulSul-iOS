//
//  AppDelegate.swift
//  App
//
//  Created by 이범준 on 2023/08/23.
//

import KakaoSDKCommon
import GoogleSignIn
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        KakaoSDK.initSDK(appKey: "3fcd336396b571c494495d0e9b42bccd")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
            var handled: Bool
            handled = GIDSignIn.sharedInstance.handle(url)
            if handled {
                return true
            }
            return false
    }
}
