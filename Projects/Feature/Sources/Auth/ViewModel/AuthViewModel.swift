//
//  AuthViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import Alamofire
import AuthenticationServices
import Foundation
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import Service

final class AuthViewModel: NSObject {
    
    private lazy var jsonDecoder = JSONDecoder()
    
    override public init() {
        super.init()
    }
    
    public func continueWithApple() {
        signin(type: .apple)
    }

    public func continueWithKakao() {
        signin(type: .kakao)
    }

    public func continueWithGoogle(id: String, item: String) {
        signin(type: .google, id: id, item: item)
    }
}

// MARK: - SignInType

extension AuthViewModel {
    enum SignInType {
        case apple, google, kakao
        
        func endpoint() -> String {
            switch self {
            case .apple: return "/auth/sign-in/apple"
            case .google: return "/auth/sign-in/google"
            case .kakao: return "/auth/sign-in/kakao"
            }
        }
    }
    
    private func signin(type: SignInType, id: String = "", item: String = "") {
        switch type {
        case .apple:
            appleAuthenticationAdapter()
        case .google:
            googleAuthenticationAdapter(id: id, item: item)
        case .kakao:
            kakaoAuthenticationAdapter()
        }
    }
}

// MARK: - Authentication

extension AuthViewModel {
    private func appleAuthenticationAdapter() {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = authorizationAppleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func googleAuthenticationAdapter(id: String, item: String) {
        let url = SignInType.google.endpoint()
        let parameters: Parameters = [
            "google_client_id": id,
            "id_token": item
        ]
        
        NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
            switch result {
            case .success(let responseData):
                if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                    let accessToken = data.accessToken
                    let tokenType = data.tokenType
                    let expiresIn = data.expiresIn
                    
                    KeychainStore.shared.create(item: accessToken, label: "accessToken")
                    print("구글 로그인 성공")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func kakaoAuthenticationAdapter() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                guard error != nil else { return }
                
                if let accessToken = oauthToken?.accessToken {
                    let url = SignInType.kakao.endpoint()
                    let parameters: Parameters = ["access_token": accessToken]
                    NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
                        switch result {
                        case .success(let responseData):
                            if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                                let accessToken = data.accessToken
                                let tokenType = data.tokenType
                                let expiresIn = data.expiresIn
                                
                                KeychainStore.shared.create(item: accessToken, label: "accessToken")
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            guard error != nil else { return }
            
            if let accessToken = oauthToken?.accessToken {
                let url = SignInType.kakao.endpoint()
                let parameters: Parameters = ["access_token": accessToken]
                NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
                    switch result {
                    case .success(let responseData):
                        if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                            let accessToken = data.accessToken
                            let tokenType = data.tokenType
                            let expiresIn = data.expiresIn
                            
                            KeychainStore.shared.create(item: accessToken, label: "accessToken")
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

// MARK: - Apple Authentication Services 델리게이트

extension AuthViewModel: ASAuthorizationControllerDelegate {
    internal func authorizationController(controller: ASAuthorizationController,
                                          didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let idToken = String(data: identityToken, encoding: .utf8) else { return }
        
        let url = SignInType.apple.endpoint()
        let parameters: Parameters = ["id_token": idToken]
        NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
            switch result {
            case .success(let responseData):
                if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                    let accessToken = data.accessToken
                    let tokenType = data.tokenType
                    let expiresIn = data.expiresIn
                    
                    KeychainStore.shared.create(item: accessToken, label: "accessToken")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("[!] Authorization Services: \(error.localizedDescription)")
    }
}
