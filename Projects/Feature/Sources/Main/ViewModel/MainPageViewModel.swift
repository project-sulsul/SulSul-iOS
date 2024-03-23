//
//  MainPageViewModel.swift
//  Feature
//
//  Created by 이범준 on 3/10/24.
//

import Foundation
import Combine
import Alamofire
import Service

struct MainPageViewModel {
    private var cancelBag = Set<AnyCancellable>()
    private let jsonDecoder = JSONDecoder()
    private let mainPageMapper = MainPageMapper()
    private let popularFeeds = CurrentValueSubject<[PopularFeed], Never> ([])
    private let differenceFeeds = CurrentValueSubject<[PopularFeed], Never> ([])
//    private let byAlcoholFeeds = CurrentValueSubject<[ByAlcoholFeed], Never> ([])
    // MARK: - (비로그인) 술 종류
    private let kindOfAlcohol = CurrentValueSubject<[CanSelectAlcoholModel], Never> ([])
    
    init() {
        getPopularFeeds()
        getDifferenceFeeds()
        getFeedsByAlcohol() // TODO: - 비로그인시에만 call
    }
    
    func getFeedsByAlcohol() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken,
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/by-alcohols", header: headers) { result in
            switch result {
            case .success(let response):
                if let alcoholFeedList = try? self.jsonDecoder.decode(RemoteFeedsByAlcoholItem.self, from: response) {
                    let mappedItem = self.mainPageMapper.kindOfAlcohol(from: alcoholFeedList.subtypes)
                    kindOfAlcohol.send(mappedItem)
                    print(">>>>>@#!@>>>")
                    print(alcoholFeedList.subtypes)
                } else {
                    print("디코딩 에러")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPopularFeeds() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken,
            "order_by_popular": "true"
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/popular", header: headers) { result in
            switch result {
            case .success(let response):
                if let popularFeedList = try? self.jsonDecoder.decode([RemotePopularFeedsItem].self, from: response) {
                    let mappedPopularFeeds = self.mainPageMapper.popularFeeds(from: popularFeedList)
                    popularFeeds.send(mappedPopularFeeds)
                    print(">>>>>1")
                    print(mappedPopularFeeds)
                } else {
                    print("디코딩 에러")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDifferenceFeeds() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken,
            "order_by_popular": "false"
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/popular", header: headers) { result in
            switch result {
            case .success(let response):
                if let differenceFeedList = try? self.jsonDecoder.decode([RemotePopularFeedsItem].self, from: response) {
                    let mappedDifferenceFeeds = self.mainPageMapper.popularFeeds(from: differenceFeedList)
                    differenceFeeds.send(mappedDifferenceFeeds)
                    
                    print(">>>>>>2")
                    print(mappedDifferenceFeeds)
                } else {
                    print("디코딩 에러")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func getFeedsByAlcoholName(_ name: String) -> {
//        
//    }
    
    func popularFeedsPublisher() -> AnyPublisher<[PopularFeed] , Never> {
        return popularFeeds.eraseToAnyPublisher()
    }
    
    func getPopularFeedsValue() -> [PopularFeed] {
        return popularFeeds.value
    }
    
    func differenceFeedsPublisher() -> AnyPublisher<[PopularFeed] , Never> {
        return differenceFeeds.eraseToAnyPublisher()
    }
    
    func getDifferenceFeedsValue() -> [PopularFeed] {
        return differenceFeeds.value
    }
    
    func getKindOfAlcoholValue() -> [CanSelectAlcoholModel] {
        return kindOfAlcohol.value
    }
    
    func isSelectedKindOfAlcohol(_ index: Int) {
        var mutable = kindOfAlcohol.value
        
        for alcoholIndex in 0..<mutable.count {
            mutable[alcoholIndex].isSelected = (alcoholIndex == index)
        }
        kindOfAlcohol.send(mutable)
    }
    
    func kindOfAlcoholPublisher() -> AnyPublisher<[CanSelectAlcoholModel], Never> {
        return kindOfAlcohol.eraseToAnyPublisher()
    }
}
