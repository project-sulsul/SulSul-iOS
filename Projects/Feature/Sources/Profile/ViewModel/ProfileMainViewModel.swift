//
//  ProfileViewModel.swift
//  Feature
//
//  Created by 이범준 on 2024/01/16.
//

import Foundation
import Combine
import Service
import Alamofire

enum UserInfoStatus: String {
    case notLogin = "notLogin"
    case banned = "banned"
    case active = "active"
}

struct ProfileMainViewModel {

    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    private let userMapper = UserMapper()
    private let tempMapper = PairingModelMapper()
    
    private let goFeedButtonIsTapped = PassthroughSubject<Void, Never>()
    private let loginButtonIsTapped = PassthroughSubject<Void, Never>()
    private var detailFeed = CurrentValueSubject<Int, Never>(0)
    private var myFeeds = CurrentValueSubject<[Feed], Never>([])
    private var likeFeeds = CurrentValueSubject<[Feed], Never>([])
    private var userInfo = CurrentValueSubject<UserInfoModel, Never>(.init(id: 0,
                                                                           uid: "",
                                                                           nickname: "",
                                                                           image: "",
                                                                           preference: .init(alcohols: [0], foods: [0]),
                                                                           status: ""))
    
    init() {
    }
    
    func getUserInfo() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else {
            userInfo.send(UserInfoModel(id: 0,
                                        uid: "",
                                        nickname: "",
                                        image: "",
                                        preference: .init(alcohols: [0],
                                                          foods: [0]),
                                        status: UserInfoStatus.notLogin.rawValue))
            return
        }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(UserDefaultsUtil.shared.getInstallationId())", header: headers) { result in
            switch result {
            case .success(let response):
                if let userData = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    let mappedUserInfo = self.userMapper.userInfoModel(from: userData)
                    userInfo.send(mappedUserInfo)
                } else {
                    print("디코딩 모델 에러5")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - 마이페이지: 내가 쓴 페이지 조회
    func getFeedsByMe() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/by-me", header: headers) { result in
            switch result {
            case .success(let response):
                if let myFeedsData = try? self.jsonDecoder.decode(RemoteFeedsItem.self, from: response) {
                    let mappedData = tempMapper.feedModel(from: myFeedsData.content ?? [])
                    myFeeds.send(mappedData)
                } else {
                    print("디코딩 모델 에러6")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendLoginButtonIsTapped() {
        loginButtonIsTapped.send(())
    }
    
    func loginButtonIsTappedPublisher() -> AnyPublisher<Void, Never> {
        return loginButtonIsTapped.eraseToAnyPublisher()
    }
    
    func sendGoFeedButtonIsTapped() {
        goFeedButtonIsTapped.send(())
    }
    
    func goFeedButtonIsTappedPublisher() -> AnyPublisher<Void, Never> {
        return goFeedButtonIsTapped.eraseToAnyPublisher()
    }
    
    func sendDetailFeed(_ id: Int) {
        detailFeed.send(id)
    }
    
    func detailFeedPublisher() -> AnyPublisher<Int, Never> {
        return detailFeed.eraseToAnyPublisher()
    }
    
    func getFeedsLikeByMe() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/liked-by-me", header: headers) { result in
            switch result {
            case .success(let response):
                if let likeFeedsData = try? self.jsonDecoder.decode(RemoteFeedsItem.self, from: response) {
                    let mappedData = tempMapper.feedModel(from: likeFeedsData.content ?? [])
                    likeFeeds.send(mappedData)
                } else {
                    print("디코딩 모델 에러7")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func myFeedsPublisher() -> AnyPublisher<[Feed], Never> {
        return myFeeds.eraseToAnyPublisher()
    }
    func getMyFeedsValue() -> [Feed] {
        return myFeeds.value
    }
    func likeFeedsPublisher() -> AnyPublisher<[Feed], Never> {
        return likeFeeds.eraseToAnyPublisher()
    }
    func getLikeFeedsValue() -> [Feed] {
        return likeFeeds.value
    }
    func userInfoPublisher() -> AnyPublisher<UserInfoModel, Never> {
        return userInfo.eraseToAnyPublisher()
    }
}

//if let encodedURL = "/pairings?type=술".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//    NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
//        switch result {
//        case .success(let responseData):
//            if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
////                        let mappedData = self.mapper.snackModel(from: pairingsData.pairings ?? [])
////                        self.dataSource = mappedData
////                        self.setCompletedDrinkData.send(())
//                print(pairingsData)
//            } else {
//                print("디코딩 모델 에러")
//            }
//        case .failure(let error):
//            print(error)
//        }
//    }
//}

//        // 키체인 테스트
//        if KeychainStore.shared.read(label: "accessToken") != nil {
//            let viewController = SetNicknameViewController()
//            window?.rootViewController = viewController
//        } else {
//            let viewController = SignInViewController()SettingViewController
//            window?.rootViewController = viewController
//        }

//
//public func requestRandomNickname() {
//    let accessToken = KeychainStore.shared.read(label: "accessToken")
//    var headers: HTTPHeaders = [
//        "Content-Type": "application/json",
//        "Authorization": "Bearer " + accessToken!
//    ]
//    
//    NetworkWrapper.shared.getBasicTask(stringURL: "/users/nickname", header: headers) { [weak self] result in
//        guard let self = self else { return }
//        switch result {
//        case .success(let responseData):
//            if let userName = self.parseRandomNickname(from: responseData) {
//                self.userNameSubject.send(userName)
//            }
//        case .failure(let error):
//            print(error)
//        }
//    }
//}
