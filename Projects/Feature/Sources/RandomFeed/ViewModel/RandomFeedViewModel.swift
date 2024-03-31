//
//  RandomFeedViewModel.swift
//  Feature
//
//  Created by 김유진 on 3/8/24.
//

import Foundation
import Service
import Combine

final class RandomFeedViewModel {
    private lazy var jsonDeoder = JSONDecoder()
    
    private var cancelBag = Set<AnyCancellable>()
    
    let errorSubject = CurrentValueSubject<String, Never>("")
    var randomFeeds: [RandomFeedModel.Feed] = []
    
    private lazy var excludeIds: [Int] = []

    // MARK: trigger
    var tappedIndex: IndexPath = .init()
    let loadRandomFeed = CurrentValueSubject<RandomFeedModel.Request, Never>(.init(exclude_feed_ids: ""))
    private lazy var updateHeart = PassthroughSubject<Int, Never>()
    
    // MARK: output
    private let reloadRandomFeeds = CurrentValueSubject<Void, Never>(())
    let reloadItem = PassthroughSubject<IndexPath, Never>()
    
    init() {
        loadRandomFeed
            .flatMap(requestRandomFeed(_:))
            .sink { [weak self] randomFeeds in
                guard let selfRef = self else { return }
                
                self?.excludeIds += selfRef.excludeIds + randomFeeds.ids_list
                self?.randomFeeds += randomFeeds.feeds
                self?.reloadRandomFeeds.send(())
            }
            .store(in: &cancelBag)
        
        updateHeart
            .flatMap(postUpdateHeart(_:))
            .sink { [weak self] heart in
                guard let selfRef = self else { return }
                
                self?.randomFeeds[selfRef.tappedIndex.item].is_liked = heart.is_liked
                
                if heart.is_liked {
                    self?.randomFeeds[selfRef.tappedIndex.item].likes_count += 1
                    
                } else {
                    self?.randomFeeds[selfRef.tappedIndex.item].likes_count -= 1
                }
                
                self?.reloadItem.send(selfRef.tappedIndex)
            }
            .store(in: &cancelBag)
    }
    
    func didTabHeart(_ index: IndexPath) {
        tappedIndex = index
        let feedId = randomFeeds[index.item].feed_id
        updateHeart.send(feedId)
    }
    
    func loadMoreData() {
        let commaSeparatedString = excludeIds.map { String($0) }.joined(separator: ",")
        
        loadRandomFeed.send(.init(exclude_feed_ids: commaSeparatedString))
    }
    
    func reloadData() -> AnyPublisher<Void, Never> {
        return reloadRandomFeeds.dropFirst().eraseToAnyPublisher()
    }
    
    private func postUpdateHeart(_ feedId: Int) -> AnyPublisher<RandomFeedModel.Heart, Never> {
        return Future<RandomFeedModel.Heart, Never> { promise in
            NetworkWrapper.shared.postBasicTask(stringURL: "/feeds/\(feedId)/like", needToken: true) { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    let decoder = JSONDecoder()
                    
                    if let data = try? decoder.decode(RandomFeedModel.Heart.self, from: success) {
                        return promise(.success(data))
                    } else {
                        print("[/feeds/id/like] fail Decoding")
                        return selfRef.errorSubject.send("[/feeds/id/like] fail Decoding")
                    }
                case .failure(let failure):
                    print("[/feeds/id/like] fail API")
                    return selfRef.errorSubject.send("[/feeds/id/like] fail API")
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func requestRandomFeed(_ request: RandomFeedModel.Request) -> AnyPublisher<RandomFeedModel.Feeds, Never> {
        return Future<RandomFeedModel.Feeds, Never> { promise in
            NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/random?exclude_feed_ids=2%2C4&size=6") { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    let decoder = JSONDecoder()
                    
                    if let data = try? decoder.decode(RandomFeedModel.Feeds.self, from: success) {
                        return promise(.success(data))
                    } else {
                        print("[/feeds/random] fail Decoding")
                        return selfRef.errorSubject.send("[/feeds/random] fail Decoding")
                    }
                case .failure(let failure):
                    print("[/feeds/random] fail API")
                    return selfRef.errorSubject.send("[/feeds/random] fail API")
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
