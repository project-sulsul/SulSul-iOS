//
//  BaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit
import Combine

open class BaseViewController: UIViewController {
    open lazy var keyboardHeight: CGFloat = 0
    
    open lazy var changedKeyboardHeight = PassthroughSubject<CGFloat, Never>()

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = DesignSystemAsset.black.color
        navigationController?.navigationBar.isHidden = true
        
        addViews()
        makeConstraints()
        setupIfNeeded()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShowChange),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHideChange),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
        // MARK: 하단 탭 바 색상이 간헐적으로 흰색으로 변경되는 현상이 있어 검은색으로 고정
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = DesignSystemAsset.black.color
            navigationController?.tabBarController?.tabBar.standardAppearance = appearance
            navigationController?.tabBarController?.tabBar.scrollEdgeAppearance = navigationController?.tabBarController?.tabBar.standardAppearance
        }
    }
    
    deinit {
        LogDebug("🌈 deinit ---> \(self)")
        deinitialize()
    }
    
    
    @objc func keyboardShowChange(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            changedKeyboardHeight.send(keyboardHeight)
            
            self.keyboardHeight = keyboardHeight
        }
    }
    
    @objc func keyboardHideChange(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            changedKeyboardHeight.send(0)
            
            self.keyboardHeight = 0
        }
    }
    
    open func addViews() {}
    
    open func makeConstraints() {}
    
    open func setupIfNeeded() {}
    
    open func deinitialize() {}
    
    open func showAlertView(withType type: AlertType,
                            title: String,
                            description: String?,
                            cancelText: String? = nil,
                            submitText: String? = nil,
                            isSubmitColorYellow: Bool = false,
                            submitCompletion: (() -> Void)?,
                            cancelCompletion: (() -> Void)?) {
        
        guard let topVC = topViewController() else { return }
        guard !(topVC is AlertViewController) else { return }
        
        let alertVC = AlertViewController(alertType: type)
        alertVC.bind(title: title, description: description, cancelText: cancelText, submitText: submitText, submitCompletion: submitCompletion, cancelCompletion: cancelCompletion)
        
        if isSubmitColorYellow {
            alertVC.submitTouchableLabel.setClickable(true)
        }
        
        alertVC.modalPresentationStyle = .overFullScreen
        topVC.present(alertVC, animated: false)
    }
    
    open func showToastMessageView(toastType: ToastType, title: String, inset: CGFloat? = nil, completion: (() -> Void)? = nil) {
        let toastView = ToastMessageView()
        toastView.bind(toastType: toastType, title: title)
        
        view.addSubview(toastView)
        view.bringSubviewToFront(toastView)
        
        toastView.snp.makeConstraints {
            let inset: CGFloat = keyboardHeight == 0 ? 102 : (inset ?? 16)
            
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(keyboardHeight + moderateScale(number: inset))
        }
        
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: { [weak self] in
            toastView.alpha = 0.0
        }, completion: { [weak self] _ in
            toastView.removeFromSuperview()
            completion?()
        })
    }
    
    open func showBottomSheetAlertView(bottomSheetAlertType: BottomSheetAlertType, title: String, submitLabel: String?, cancelLabel: String?, description: String?, submitCompletion: (() -> Void)?,
                                       cancelCompletion: (() -> Void)?) {
        guard !view.subviews.contains(where: { $0 is BottomSheetAlertView }) else { return }
        let bottomSheetAlertView = BottomSheetAlertView(bottomSheetAlertType: bottomSheetAlertType)
        bottomSheetAlertView.bind(title: title,
                                  description: description,
                                  submitLabel: submitLabel,
                                  cancelLabel: cancelLabel,
                                  submitCompletion: submitCompletion,
                                  cancelCompletion: cancelCompletion)
        view.addSubview(bottomSheetAlertView)
        view.bringSubviewToFront(bottomSheetAlertView)
    }
    
    open func showCameraBottomSheet(selectCameraCompletion: (() -> Void)?,
                                    selectAlbumCompletion: (() -> Void)?,
                                    baseCompletion: (() -> Void)?) {
        let cameraBottomSheet = CameraBottomSheet()
        cameraBottomSheet.bind(selectCameraCompletion: selectCameraCompletion,
                               selectAlbumCompletion: selectAlbumCompletion,
                               selectBaseCompletion: baseCompletion)
        view.addSubview(cameraBottomSheet)
        view.bringSubviewToFront(cameraBottomSheet)
    }
    
    public func topViewController() -> UIViewController? {
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
}
