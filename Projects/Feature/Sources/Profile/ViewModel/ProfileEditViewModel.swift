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
    
    private let userId: Int = 1
    private let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIiLCJpYXQiOjE3MDU3NDk4MDEsImV4cCI6MTcwNjM1NDYwMSwiaWQiOjEsInNvY2lhbF90eXBlIjoiZ29vZ2xlIiwic3RhdHVzIjoiYWN0aXZlIn0.gucj-5g1CktXtAKqYp99K-_eI7sH_VmoyDTaVhKE6DU"
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    
    private let randomNickname = PassthroughSubject<String, Never>()
    
    init() {
        getRandomNickname()
        getUserInfo(userId: 1)
    }
    
    func getRandomNickname() {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + self.accessToken
        ]
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/nickname", header: headers) { result in
            switch result {
            case .success(let response):
                if let nickname = try? self.jsonDecoder.decode(UserName.self, from: response) {
                    randomNickname.send(nickname.value)
                } else {
                    print("디코딩 모델 에러")
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
                    print(">>>>>>>>")
                    print(userInfo)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 아직 테스트 x
    func deleteUser(userId: Int) {
        NetworkWrapper.shared.deleteBasicTask(stringURL: "/users/\(userId)") { result in
            switch result {
            case .success(_):
                print("삭제 성공")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func randomNicknamePublisher() -> AnyPublisher<String, Never> {
        return randomNickname.eraseToAnyPublisher()
    }
}
