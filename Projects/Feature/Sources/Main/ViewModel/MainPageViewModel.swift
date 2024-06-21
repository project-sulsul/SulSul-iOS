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

final class MainPageViewModel {
    private var cancelBag = Set<AnyCancellable>()
    private let jsonDecoder = JSONDecoder()
    private let userMapper = UserMapper()
    private let mainPageMapper = MainPageMapper()
    private let popularFeeds = CurrentValueSubject<[PopularFeed], Never>([])
    private let differenceFeeds = CurrentValueSubject<[PopularFeed], Never>([])
    // MARK: - (비로그인) 술 종류
    private let kindOfAlcohol = CurrentValueSubject<[SelectableAlcohol], Never>([])
    private let alcoholFeeds = CurrentValueSubject<[AlcoholFeed.Feed], Never>([])
    private let selectedAlcoholFeeds = CurrentValueSubject<[AlcoholFeed.Feed], Never>([])
    private let selectedAlcohol = CurrentValueSubject<String, Never>("")
    private let errorSubject = CurrentValueSubject<String, Never>("")
    
    private var userInfo = CurrentValueSubject<UserInfoModel, Never>(.init(id: 0,
                                                                           uid: "",
                                                                           nickname: "",
                                                                           image: "",
                                                                           preference: .init(alcohols: [0], foods: [0]),
                                                                           status: UserInfoStatus.notLogin.rawValue))
    
    private let completeAllFeed = PassthroughSubject<Void, Never>()
    
    init() {
        bind()
    }
    
    private func bind() {
        popularFeeds
            .combineLatest(differenceFeeds, alcoholFeeds)
            .sink { [weak self] _, _, _ in
                guard let self = self else { return }
                completeAllFeed.send(())
            }.store(in: &cancelBag)
    }
    
    func getFeedsByAlcohol() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/by-alcohols") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let alcoholFeedList = try? self.jsonDecoder.decode(RemoteFeedsByAlcoholItem.self, from: response) {
                    let mappedAlcoholFeedList = self.mainPageMapper.remoteToAlcoholFeeds(from: alcoholFeedList)
                    var selectableAlcohols: [SelectableAlcohol] = mappedAlcoholFeedList.subtypes.map { SelectableAlcohol(title: $0, isSelected: false) }
                    if let firstIndex = selectableAlcohols.indices.first {
                        selectableAlcohols[firstIndex].isSelected = true
                    }
                    self.alcoholFeeds.send(mappedAlcoholFeedList.feeds)
                    self.kindOfAlcohol.send(selectableAlcohols)
                    self.sendSelectedAlcoholFeed(mappedAlcoholFeedList.subtypes.first ?? "")
                    self.selectedAlcohol.send(mappedAlcoholFeedList.subtypes.first ?? "")
                } else {
                    self.errorSubject.send("엡에서 에러가 발생했습니다")
                }
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func getPopularFeeds() {
        let headers: HTTPHeaders = [
            "order_by_popular": "true"
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/popular", header: headers) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let popularFeedList = try? self.jsonDecoder.decode([RemotePopularFeedsItem].self, from: response) {
                    let mappedPopularFeeds = self.mainPageMapper.popularFeeds(from: popularFeedList)
                    self.popularFeeds.send(mappedPopularFeeds)
                } else {
                    self.errorSubject.send("엡에서 에러가 발생했습니다")
                }
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func getDifferenceFeeds() {
        var headers: HTTPHeaders = [
            "order_by_popular": "false"
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/popular", header: headers) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let differenceFeedList = try? self.jsonDecoder.decode([RemotePopularFeedsItem].self, from: response) {
                    let mappedDifferenceFeeds = self.mainPageMapper.popularFeeds(from: differenceFeedList)
                    self.differenceFeeds.send(mappedDifferenceFeeds)
                } else {
                    self.errorSubject.send("엡에서 에러가 발생했습니다")
                }
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func getPreferenceFeeds() {
        print("호출1")
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        print("호출2")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/by-preferences", header: headers) { result in
            switch result {
            case .success(let response):
                if let alcoholFeedList = try? self.jsonDecoder.decode(RemoteFeedsByAlcoholItem.self, from: response) {
                    let mappedAlcoholFeedList = self.mainPageMapper.remoteToAlcoholFeeds(from: alcoholFeedList)
                    self.selectedAlcoholFeeds.send(mappedAlcoholFeedList.feeds)
                } else {
                    self.errorSubject.send("엡에서 에러가 발생했습니다")
                }
            case .failure(let error):
                print(">>>>>")
                print(error)
                self.errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func getUserInfo() {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else {
            userInfo.send(UserInfoModel(id: 0,
                                        uid: "",
                                        nickname: "",
                                        image: "",
                                        preference: .init(alcohols: [0],
                                                          foods: [0]),
                                        status: UserInfoStatus.notLogin.rawValue))
            return
        }
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(UserDefaultsUtil.shared.getInstallationId())", header: headers) { result in
            switch result {
            case .success(let response):
                if let userData = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    let mappedUserInfo = self.userMapper.userInfoModel(from: userData)
                    self.userInfo.send(mappedUserInfo)
                } else {
                    self.errorSubject.send("엡에서 에러가 발생했습니다")
                }
            case .failure(let error):
                self.errorSubject.send(error.localizedDescription)
            }
        }
    }
    
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
    
    func userInfoPublisher() -> AnyPublisher<UserInfoModel, Never> {
        return userInfo.eraseToAnyPublisher()
    }
    
    func getUserInfoValue() -> UserInfoModel {
        return userInfo.value
    }

    func selectedAlcoholFeedPublisher() -> AnyPublisher<[AlcoholFeed.Feed], Never> {
        return selectedAlcoholFeeds.eraseToAnyPublisher()
    }
    
    func sendSelectedAlcoholFeed(_ alcohol: String) {
        let allAlcoholFeeds = alcoholFeeds.value
        let selectedFeeds = allAlcoholFeeds.filter { $0.subtype == alcohol }
        selectedAlcohol.send(alcohol)
        var kindOfAlcoholValue = kindOfAlcohol.value
        if let index = kindOfAlcoholValue.firstIndex(where: { $0.title.lowercased() == alcohol }) {
            for (i, _) in kindOfAlcoholValue.enumerated() {
                kindOfAlcoholValue[i].isSelected = (i == index)
            }
        }
        kindOfAlcohol.send(kindOfAlcoholValue)
        selectedAlcoholFeeds.send(selectedFeeds)
    }
    
    func getSelectedAlcoholValue() -> String {
        return selectedAlcohol.value
    }
    
    func getSelectedAlcoholFeedsValue() -> [AlcoholFeed.Feed] {
        return selectedAlcoholFeeds.value
    }
    
    func getKindOfAlcoholValue() -> [SelectableAlcohol] {
        return kindOfAlcohol.value
    }
    
    func completeAllFeedPublisher() -> AnyPublisher<Void, Never> {
        return completeAllFeed.eraseToAnyPublisher()
    }
    
    func getErrorSubject() -> AnyPublisher<String, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
