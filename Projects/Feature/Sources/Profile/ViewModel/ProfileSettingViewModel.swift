//
//  ProfileSettingViewModel.swift
//  Feature
//
//  Created by 이범준 on 1/21/24.
//

import Foundation
import Combine
import Alamofire
import Service

struct ProfileSettingViewModel {
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    private let userMapper = UserMapper()
    
    private var deleteUserIsCompleted = PassthroughSubject<Bool, Never>()
    
    init() {
       
    }
    
    func deleteUser() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
    
        NetworkWrapper.shared.deleteBasicTask(stringURL: "/users/\(UserDefaultsUtil.shared.getInstallationId())", header: headers) { result in
            switch result {
            case .success(let response):
                if let userData = try? self.jsonDecoder.decode(RemoteDeleteUserItem.self, from: response) {
                    let mappedUserData = self.userMapper.deleteUserModel(from: userData)
                    print(mappedUserData)
                    deleteUserIsCompleted.send(mappedUserData.result)
                } else {
                    print("디코딩 모델 에러5")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteUserIsCompletedPublisher() -> AnyPublisher<Bool, Never> {
        return deleteUserIsCompleted.eraseToAnyPublisher()
    }
}
