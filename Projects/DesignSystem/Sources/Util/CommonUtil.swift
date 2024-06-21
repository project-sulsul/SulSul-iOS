//
//  CommonUtil.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

public final class CommonUtil {
    static let shared = CommonUtil()
    
    private init() {}
    
    public enum AppStore: String {
        // TODO: appStore 주소
        case appStore = ""
    }
    
    public func versionCode() -> String {
        if let info = Bundle.main.infoDictionary,
           let version = info["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    public func updateApp() {
        if let url = URL(string: AppStore.appStore.rawValue), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.last { $0.isKeyWindow }
        var topVC = keyWindow?.rootViewController
        
        while true {
            if let presented = topVC?.presentedViewController {
                topVC = presented
            } else if let navigationController = topVC as? UINavigationController {
                topVC = navigationController.visibleViewController
            } else if let tabBarController = topVC as? UITabBarController {
                topVC = tabBarController.selectedViewController
            } else {
                break
            }
        }
        
        return topVC
    }
    
    public static func showLoadingView() {
        guard UIApplication.shared.windows.last?.subviews.contains(where: { $0 is LoadingView }) == false else { return }
        
        let loadingView = LoadingView()
        loadingView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        UIApplication.shared.windows.last?.addSubview(loadingView)
    }
    
    public static func hideLoadingView() {
        if let loadingView = UIApplication.shared.windows.last?.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        } else if let loadingView = UIApplication.shared.windows.first?.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        } else if let topVC = CommonUtil.topViewController(), let loadingView = topVC.view.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        }
    }
}
