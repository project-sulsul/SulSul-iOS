//
//  SetNicknameViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import Foundation
import Combine
import Service
import Alamofire

public final class SetNicknameViewModel {
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    
    // PassthroughSubject를 사용해서 외부로 전달하기
    var userNameSubject = PassthroughSubject<String, Never>()
    private var setUserName = PassthroughSubject<Void, Never>()
    
    var userName: String = ""
    
    public init() {}
    
    private func parseRandomNickname(from data: Data) -> String? {
        do {
            let response = try jsonDecoder.decode(Nickname.self, from: data)
            return response.value
        } catch {
            print("parseRandomNickname(): \(error)")
            return nil
        }
    }
    
    func sendSetUserName(userId: Int, userNickName: String) {
        let accessToken = KeychainStore.shared.read(label: "accessToken")
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken!
        ]
        
        let params: [String: Any] = ["nickname": userNickName]
        
        networkWrapper.putBasicTask(stringURL: "/users/\(userId)/nickname", parameters: params,header: headers) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                setUserName.send(())
            case .failure(let error):
                print("닉네임 설정 실패")
                print(error)
            }
        }
    }
    
    func userNamePublisher() -> AnyPublisher<String, Never> {
        return userNameSubject.eraseToAnyPublisher()
    }
    
    func setUserNamePublisher() -> AnyPublisher<Void, Never> {
        return setUserName.eraseToAnyPublisher()
    }
}
