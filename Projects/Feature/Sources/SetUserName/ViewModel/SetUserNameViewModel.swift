//
//  SelectUserNameViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import Foundation
import Combine
import Service
import Alamofire

final class SelectUserNameViewModel: NSObject {
    
    private let jsonDecoder = JSONDecoder()
    
    // PassthroughSubject를 사용해서 외부로 전달하기
    var userNameSubject = PassthroughSubject<String, Never>()
    
    var userName: String = ""
    
    public func requestRandomNickname() {
        let accessToken = KeychainStore.shared.read(label: "accessToken")
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken!
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/nickname", header: headers) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseData):
                if let userName = self.parseRandomNickname(from: responseData) {
                    self.userNameSubject.send(userName)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func parseRandomNickname(from data: Data) -> String? {
        do {
            let response = try jsonDecoder.decode(UserName.self, from: data)
            return response.value
        } catch {
            print("parseRandomNickname(): \(error)")
            return nil
        }
    }
    
    public func userNamePublisher() -> AnyPublisher<String, Never> {
        return userNameSubject.eraseToAnyPublisher()
    }
}
