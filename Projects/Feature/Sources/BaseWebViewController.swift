//
//  BaseWebViewController.swift
//  Feature
//
//  Created by 이범준 on 4/18/24.
//

import UIKit
import Combine
import WebKit
import SnapKit
import DesignSystem
import Then

protocol BaseWebViewControllerDelegate: AnyObject {
    func webVCDidDisappear()
}

public class BaseWebViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: CommonBaseCoordinator?
    
    private lazy var topContainerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
    }
    
    private lazy var backTouchableView = TouchableView()
    
    private lazy var backImageView = UIImageView().then {
        $0.image = UIImage(named: "common_leftArrow")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel()
    
    private lazy var webViewProgressView = UIProgressView().then {
        $0.progressTintColor = DesignSystemAsset.main.color
        $0.trackTintColor = .white
    }
    
    private lazy var webView = WKWebView().then {
        $0.allowsBackForwardNavigationGestures = true
        $0.overrideUserInterfaceStyle = .dark
        $0.navigationDelegate = self
        $0.scrollView.showsVerticalScrollIndicator = false
    }
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = DesignSystemAsset.black.color
        
        openWebView(with: url)
    }
    
    public override func addViews() {
        view.addSubviews([topContainerView, webView])
        topContainerView.addSubviews([backTouchableView, titleLabel, webViewProgressView])
        backTouchableView.addSubview(backImageView)
    }
    
    public override func makeConstraints() {
        topContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(getSafeAreaTop())
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 60))
        }
        
        backTouchableView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
            $0.size.equalTo(moderateScale(number: 36))
        }
        
        backImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backTouchableView.snp.trailing)
        }
        
        webViewProgressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 2))
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
    }
    
    public override func setupIfNeeded() {
        backTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            if self?.webView.canGoBack == true {
                self?.webView.goBack()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    public override func deinitialize() {
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            webViewProgressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress == 1.0 {
                webViewProgressView.isHidden = true
            }
        }
    }
    
    private func openWebView(with url: URL) {
        let urlRequest = URLRequest(url: url)
        
        DispatchMain.async { [weak self] in
            self?.webView.load(urlRequest)
        }
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
