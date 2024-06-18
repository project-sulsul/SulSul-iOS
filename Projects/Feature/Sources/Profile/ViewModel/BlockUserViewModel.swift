//
//  BlockUserViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-06-01.
//

import Foundation
import Combine
import Service
import Alamofire

final class BlockUserViewModel {
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    private var cancelBag = Set<AnyCancellable>()
    private var isUnblocked = PassthroughSubject<Bool, Never>()
    
    var blockUsers: [BlockUser] = []
    
    init() {
        self.blockUsers = UserDefaultsUtil.shared.getObjects(BlockUser.self, forKey: .blockUser) ?? []
    }
    
    func isUnblockedPublisher() -> AnyPublisher<Bool, Never> {
        return isUnblocked.eraseToAnyPublisher()
    }
}

// MARK: - API Requests
//
extension BlockUserViewModel {
    public func requestUnblockUser(_ userId: Int) {
        var headers: HTTPHeaders? = nil
        
        if UserDefaultsUtil.shared.isLogin() {
            guard let accessToken = KeychainStore.shared.read(label: "accessToken")
            else { return }
            debugPrint("\(#function): User accessToken is \(accessToken)")
            
            headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken
            ]
        }
        
        networkWrapper.deleteBasicTask(stringURL: "/users/\(userId)/block", header: headers) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.isUnblocked.send(true)
                debugPrint("\(#function) -- Request succeed.")
            case .failure(let error):
                debugPrint("\(#function) -- Request failed. Reason is \(error)")
            }
        }
    }
    
    public func deleteBlockUser(_ user: BlockUser) {
        UserDefaultsUtil.shared.removeObject(user, forKey: .blockUser)
        
        if let index = blockUsers.firstIndex(of: user) {
            blockUsers.remove(at: index)
        }
    }
}
