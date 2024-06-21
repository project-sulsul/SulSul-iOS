//
//  RewriteContentViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-21.
//

import Foundation
import Combine
import Service
import Alamofire

final class RewriteContentViewModel {
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    
    private var cancelBag = Set<AnyCancellable>()
    private var successSubject = CurrentValueSubject<Void, Never>(())
    private var errorSubject = CurrentValueSubject<NetworkError, Never>(NetworkError(message: ""))
    
    init() {}
}

// MARK: - API Request
//
extension RewriteContentViewModel {
    func updateFeed(
        feedID: Int,
        title: String,
        content: String,
        images: [String]? = [],
        userTags: [String]? = nil
    ) {
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
        
        let parameters: [String: Any] = [
            "title": title,
            "content": content,
            "images": images ?? [],
            "user_tags": userTags ?? []
        ]
        
        networkWrapper.putBasicTask(stringURL: "/feeds/\(feedID)", parameters: parameters, header: headers) { [weak self] result in
            switch result {
            case .success(let response):
                self?.successSubject.send(())
                debugPrint("\(#function) -- Decoding succeed.")
            case .failure(let error):
                self?.errorSubject.send(NetworkError.init(message: "\(#function) -- API request failed, reason is \(error.localizedDescription)"))
                debugPrint("\(#function) -- API request failed, reason is \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Publisher
//
extension RewriteContentViewModel {
    func updateFeedPublisher() -> AnyPublisher<Void, Never> {
        return successSubject.eraseToAnyPublisher()
    }
}
