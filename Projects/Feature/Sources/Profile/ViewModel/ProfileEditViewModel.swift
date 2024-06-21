//
//  ProfileEditViewModel.swift
//  Feature
//
//  Created by 이범준 on 1/21/24.
//

import Foundation
import Combine
import Alamofire
import Service
import UIKit

struct ProfileEditViewModel {
    
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    private let userMapper = UserMapper()
    
    private let errorSubject = CurrentValueSubject<String, Never>("")
    private let randomNickname = PassthroughSubject<String, Never>()
    private var setUserName = PassthroughSubject<Void, Never>()
    
    init() {
        
    }
    
    func getRandomNickname() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/nickname", header: headers) { result in
            switch result {
            case .success(let response):
                if let nickname = try? self.jsonDecoder.decode(Nickname.self, from: response) {
                    randomNickname.send(nickname.value)
                } else {
                    errorSubject.send("엡에서 에러가 발생했습니다")
                }
            case .failure(let error):
                errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func getUserInfo() {
        let userId = UserDefaultsUtil.shared.getInstallationId()
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(userId)") { result in
            switch result {
            case .success(let response):
                if let userInfo = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    let mappedUserInfo = self.userMapper.userInfoModel(from: userInfo)
                    randomNickname.send(mappedUserInfo.nickname)
                } else {
                    errorSubject.send("엡에서 에러가 발생했습니다")
                }
            case .failure(let error):
                errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func setNickname(_ nickname: String) {
        let userId = UserDefaultsUtil.shared.getInstallationId()
        
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        
        let params: [String: Any] = ["nickname": nickname]
        
        NetworkWrapper.shared.putBasicTask(stringURL: "/users/\(userId)/nickname", parameters: params, header: headers) { result in
            switch result {
            case .success(let response):
                setUserName.send(())
            case .failure(let error):
                errorSubject.send(error.localizedDescription)
            }
        }
    }
    

//    func setProfileImage(imageUrl: String) {
//        let userId = UserDefaultsUtil.shared.getInstallationId()
//        
//        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
//        var headers: HTTPHeaders = [
//            "Authorization": "Bearer " + accessToken
//        ]
//        
//        // 이미지 URL을 쿼리 파라미터로 포함하여 요청을 보냅니다.
//        let urlString = "/users/\(userId)/image?image_url=\(imageUrl)"
//        

//        NetworkWrapper.shared.putUploadImage(stringURL: urlString, header: headers) { result in
//            switch result {
//            case .success(let imageData):
//                if let userData = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: imageData) {
//                    print(userData)
//                } else {
//                    errorSubject.send("서버 응답에 오류가 있습니다.")
//                }
//            case .failure(let error):
//                errorSubject.send("이미지 업로드 중 오류가 발생했습니다.")
//            }
//        }
//    }
    
    func randomNicknamePublisher() -> AnyPublisher<String, Never> {
        return randomNickname.eraseToAnyPublisher()
    }

    func setUserNamePublisher() -> AnyPublisher<Void, Never> {
        return setUserName.eraseToAnyPublisher()
    }
}
