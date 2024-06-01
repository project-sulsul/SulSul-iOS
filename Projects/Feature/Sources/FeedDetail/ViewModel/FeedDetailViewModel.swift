//
//  FeedDetailViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import Foundation
import Service
import Alamofire

public final class FeedDetailViewModel {
    var feedID: Int
    /// 현재 피드와 관련된 다른 피드
    var relatedFeeds: [RelatedFeed] = []
    
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    /// 현재 피드 ID에 대한 상세 데이터
    private var detail = PassthroughSubject<FeedDetail, Never>()
    /// 현재 피드 ID에 대한 이미지
    private var feedImages = PassthroughSubject<[String], Never>()
    /// 현재 피드에 포함된 이미지 개수
    private var numberOfFeedImages = CurrentValueSubject<Int, Never>(0)
    /// 현재 피드가 포함하고 있는 댓글 개수
    private var numberOfComments = CurrentValueSubject<Int, Never>(0)
    /// 현재 피드의 페어링 주류 이름
    private var pairingDrinkName = CurrentValueSubject<String, Never>("")
    /// 현재 피드의 페어링 안주 이름
    private var pairingSnackName = CurrentValueSubject<String, Never>("")
    /// 술 이름을 받아오기 위한 페어링 아이디 값
    private var pairingDrinkID = CurrentValueSubject<Int, Never>(0)
    /// 안주 이름을 받아오기 위한 페어링 아이디 값
    private var pairingSnackID = CurrentValueSubject<Int, Never>(0)
    /// 사용자 태그
    private var userTags = PassthroughSubject<[String], Never>()
    /// 좋아요 표시
    private let isLiked = CurrentValueSubject<Bool, Never>(false)
    /// 피드 삭제 처리 여부
    private var isDeleted = CurrentValueSubject<Bool, Never>(false)
    /// 사용자 차단 여부
    private var isBlocked = CurrentValueSubject<Bool, Never>(false)
    /// 현재 피드와 관련된 다른 피드 개수
    private var numberOfRelatedFeed = CurrentValueSubject<Int, Never>(0)
    private var cancelBag = Set<AnyCancellable>()
    
    public init(feedID: Int) {
        self.feedID = feedID
        
        self.requestDetail()
        self.requestRelatedFeeds()
    }
    
    public func fetchCommentCount() -> Int {
        return numberOfComments.value
    }
    
    public func fetchRelatedFeedCount() -> Int {
        return numberOfRelatedFeed.value
    }
}

// MARK: - Publisher
//
extension FeedDetailViewModel {
    func detailPublisher() -> AnyPublisher<FeedDetail, Never> {
        return detail.eraseToAnyPublisher()
    }
    
    func feedImagePublisher() -> AnyPublisher<[String], Never> {
        return feedImages.eraseToAnyPublisher()
    }
    
    func pairingSnackPublisher() -> AnyPublisher<String, Never> {
        return pairingSnackName.eraseToAnyPublisher()
    }

    func pairingDrinkPublisher() -> AnyPublisher<String, Never> {
        return pairingDrinkName.eraseToAnyPublisher()
    }
    
    func isLikedPublisher() -> AnyPublisher<Bool, Never> {
        return isLiked.eraseToAnyPublisher()
    }
    
    func isDeletedPublisher() -> AnyPublisher<Bool, Never> {
        return isDeleted.eraseToAnyPublisher()
    }
    
    func isBlockedPublisher() -> AnyPublisher<Bool, Never> {
        return isDeleted.eraseToAnyPublisher()
    }
}

// MARK: - Request method
//
extension FeedDetailViewModel {
    private func requestDetail() {
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
        
        networkWrapper.getBasicTask(stringURL: "/feeds/\(feedID)", header: headers) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try self.jsonDecoder.decode(FeedDetail.self, from: response)
                    
                    debugPrint("\(#function): \(data)")
                    
                    self.detail.send(data)
                    self.numberOfComments.send(data.commentCount)
                    self.isLiked.send(data.isLiked)
                    
                    guard let alcoholPairingID = data.alcoholPairingIDs.first,
                          let snackPairingID = data.snackPairingIDs.first,
                          let userTags = data.userTags
                    else { return }
                    
                    self.pairingDrinkID.send(alcoholPairingID)
                    self.pairingSnackID.send(snackPairingID)
                    self.userTags.send(userTags)
                    
                    self.pairingDrinkID
                        .sink { [weak self] value in
                            self?.requestPairingDrink(value)
                        }
                        .store(in: &cancelBag)
                    
                    self.pairingSnackID
                        .sink { [weak self] value in
                            self?.requestPairingSnack(value)
                        }
                        .store(in: &cancelBag)
                } catch {
                    debugPrint("\(#function): Decoding failed, Reason is: \(error.localizedDescription)")
                }
            case .failure(let error):
                debugPrint("\(self): Request failed, Reason is: \(error.localizedDescription)")
            }
        }
    }

    private func requestPairingDrink(_ alcoholPairingID: Int) {
        networkWrapper.getBasicTask(stringURL: "/pairings/\(alcoholPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let drinkName = data.name else { return }
                    self.pairingDrinkName.send(drinkName)
                }
            case .failure(let error):
                print("\(#function): \(error)")
            }
        }
    }
    
    private func requestPairingSnack(_ foodPairingID: Int) {
        networkWrapper.getBasicTask(stringURL: "/pairings/\(foodPairingID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    guard let snackName = data.name else { return }
                    self.pairingSnackName.send(snackName)
                }
            case .failure(let error):
                print("\(#function): \(error)")
            }
        }
    }
    
    public func requestLikeFeed(_ feedID: Int) {
        NetworkWrapper.shared.postBasicTask(stringURL: "/feeds/\(feedID)/like", needToken: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try self.jsonDecoder.decode(RandomFeedModel.Heart.self, from: response)
                    
                    self.isLiked.send(data.is_liked)
                    debugPrint("\(#function): Decoding succeed, \(data)")
                } catch {
                    debugPrint("\(#function): Decoding failed, Reason is: \(error.localizedDescription)")
                }
            case .failure(let error):
                debugPrint("\(#function): Request failed, Reason is: \(error.localizedDescription)")
            }
        }
    }
    
    public func requestRelatedFeeds() {
        networkWrapper.getBasicTask(stringURL: "/feeds/\(feedID)/related-feeds?next_feed_id=0&size=6") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try self.jsonDecoder.decode(CursorPageResponse.self, from: response)
                    
                    self.relatedFeeds = data.content
                    self.numberOfRelatedFeed.send(data.content.count)
                    
                    debugPrint("\(#function): Decoding succeed, \(data)")
                } catch {
                    debugPrint("\(#function): Decoding failed, Reason is: \(error.localizedDescription)")
                }
            case .failure(let error):
                debugPrint("\(#function): Request failed, Reason is: \(error.localizedDescription)")
            }
        }
    }
    
    public func requestDelete() {
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
        
        networkWrapper.deleteBasicTask(stringURL: "/feeds/\(feedID)", header: headers) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try self.jsonDecoder.decode(DeleteFeedResponse.self, from: response)
                    
                    self.isDeleted.send(data.isDeleted)
                    
                    debugPrint("\(#function): Decoding succeed, \(data)")
                } catch {
                    debugPrint("\(#function): Decoding failed, Reason is: \(error.localizedDescription)")
                }
            case .failure(let error):
                debugPrint("\(#function): Request failed, Reason is: \(error.localizedDescription)")
            }
        }
    }
    
    public func requestBlockUser(userId: Int) {
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
        
        networkWrapper.postBasicTask(stringURL: "/users/\(userId)/block", header: headers) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? self.jsonDecoder.decode(Block.self, from: response) {
                    self.setBlockUser(userId: data.targetUserID)
                    self.isBlocked.send(true)
                    
                    debugPrint("\(#function) -- Request succeed.")
                }
            case .failure(let error):
                debugPrint("\(#function) -- Request failed. Reason is \(error.localizedDescription)")
            }
        }
    }
    
    private func setBlockUser(userId: Int) {
        networkWrapper.getBasicTask(stringURL: "/users/\(userId)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? self.jsonDecoder.decode(BlockUser.self, from: response) {
                    UserDefaultsUtil.shared.setObject(data, forkey: .blockUser)
                }
            case .failure(let error):
                debugPrint("\(#function) -- Request failed. Reason is \(error.localizedDescription)")
            }
        }
    }
}
