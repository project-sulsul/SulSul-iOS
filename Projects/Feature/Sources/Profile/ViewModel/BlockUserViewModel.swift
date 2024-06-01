//
//  BlockUserViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-06-01.
//

import Foundation
import Combine
import Service

final class BlockUserViewModel {
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    private var cancelBag = Set<AnyCancellable>()
    private var isUnblocked = CurrentValueSubject<Bool, Never>(false)
    
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
        networkWrapper.deleteBasicTask(stringURL: "/users/\(userId)/block") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.isUnblocked.send(true)
                debugPrint("\(#function) -- Request succeed.")
            case .failure(let error):
                debugPrint("\(#function) -- Request failed. Reason is \(error.localizedDescription)")
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
