//
//  BaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = .white
        
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    deinit {
        LogDebug("🌈 deinit ---> \(self)")
        deinitialize()
    }
    
    open func addViews() {}
    
    open func makeConstraints() {}
    
    open func setupIfNeeded() {}
    
    open func deinitialize() {}
    
    open func showAlertView(withType type: AlertType,
                       title: String,
                       description: String?,
                       submitCompletion: (() -> Void)?,
                       cancelCompletion: (() -> Void)?) {
        let alertView = AlertView(alertType: type)
        alertView.bind(title: title, description: description, submitCompletion: submitCompletion, cancelCompletion: cancelCompletion)
        
        view.addSubview(alertView)
        view.bringSubviewToFront(alertView)
    }
    
    open func showToastMessageView(toastType: ToastType, title: String) {
        let toastView = ToastMessageView()
        toastView.bind(toastType: toastType, title: title)
        view.addSubview(toastView)
        view.bringSubviewToFront(toastView)
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut, animations: { [weak self] in
            toastView.alpha = 0.0
        }, completion: { [weak self] _ in
            toastView.removeFromSuperview()
        })
    }
}
