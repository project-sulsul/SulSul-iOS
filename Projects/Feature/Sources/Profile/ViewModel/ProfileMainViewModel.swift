//
//  ProfileViewModel.swift
//  Feature
//
//  Created by 이범준 on 2024/01/16.
//

import Foundation
import Combine
import Service
import Alamofire // TODO: - Alamofire는 Service에서만 사용되도록 로직 수정 필요

struct ProfileMainViewModel {

    private let userId = UserDefaultsUtil.shared.getInstallationId()
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    private let userMapper = UserMapper()
    
    private var myFeeds = CurrentValueSubject<[Feed], Never>([])
    private var likeFeeds = CurrentValueSubject<[Feed], Never>([])
    private var userInfo = PassthroughSubject<UserInfoModel, Never>()
    
    init() {
    }
    
    func getUserInfo() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(userId)", header: headers) { result in
            switch result {
            case .success(let response):
                if let userData = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    let mappedUserInfo = self.userMapper.userInfoModel(from: userData)
                    print("여기>>>>")
                    print(mappedUserInfo)
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
                    myFeeds.send(myFeedsData.content)
                } else {
                    print("디코딩 모델 에러6")
                }
            case .failure(let error):
                print(error)
            }
        }
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
                    likeFeeds.send(likeFeedsData.content)
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
//            let viewController = SetUserNameViewController()
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
