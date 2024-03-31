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

struct ProfileEditViewModel {
    
    private let userId = UserDefaultsUtil.shared.getInstallationId()
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    private let userMapper = UserMapper()
    
    private let randomNickname = PassthroughSubject<String, Never>()
    private var setUserName = PassthroughSubject<Void, Never>()
    
    init() {
        getUserInfo(userId: 1)
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
                if let nickname = try? self.jsonDecoder.decode(UserName.self, from: response) {
                    randomNickname.send(nickname.value)
                } else {
                    print("디코딩 모델 에러4")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    // MARK: - ID로 유저 정보를 조회
    func getUserInfo(userId: Int) {
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(userId)") { result in
            switch result {
            case .success(let response):
                if let userInfo = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    let mappedUserInfo = self.userMapper.userInfoModel(from: userInfo)
                    print("여기 이제 값 가져와서 모델에 넣어놓자")
                } else {
                    print("디코딩 에러")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setNickname(_ nickname: String) {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        
        let params: [String: Any] = ["nickname": nickname]
        
        NetworkWrapper.shared.putBasicTask(stringURL: "/users/\(userId)/nickname", parameters: params,header: headers) { result in
            switch result {
            case .success(let response):
                setUserName.send(())
            case .failure(let error):
                print("닉네임 설정 실패")
                print(error)
            }
        }
    }
    
    func randomNicknamePublisher() -> AnyPublisher<String, Never> {
        return randomNickname.eraseToAnyPublisher()
    }

    func setUserNamePublisher() -> AnyPublisher<Void, Never> {
        return setUserName.eraseToAnyPublisher()
    }
}
