//
//  DetailFeedViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import Foundation
import Service

public final class DetailFeedViewModel {
    private let jsonDecoder = JSONDecoder()
    
    private var currentFeedID: Int
    private var cancelBag = Set<AnyCancellable>()
    private var detailFeedSubject = PassthroughSubject<DetailFeed.Feed, Never>()
    private var feedImageSubject = PassthroughSubject<[String], Never>()
    private var detailFeedImageSubject = PassthroughSubject<[String], Never>()
    private var pairingDrinkSubject = PassthroughSubject<String, Never>()
    private var pairingSnackSubject = PassthroughSubject<String, Never>()
    private var feedImageDatasource: [String] = []
    
    public init(feedID: Int) {
        self.currentFeedID = feedID
        
        requestDetailFeed()
    }
    
    public func requestDetailFeed() {
        let feedID = currentFeedID
        print("DetailFeedViewModel.requestDetailFeed() called")
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedID)") { [weak self] result in
            
            switch result {
            case .success(let response):
                do {
                    let data = try self?.jsonDecoder.decode(DetailFeed.Feed.self, from: response)
                    print("DetailFeedViewModel.requestDetailFeed(): \(String(describing: data))")
                    
                    self?.detailFeedSubject.send(data!)
                    
                    guard let alcoholPairingID = data?.alcoholPairingIDs.first,
                          let snackPairingID = data?.snackPairingIDs.first
                    else { return }
                    
                    self?.requestParingDrink(alcoholPairingID)
                    self?.requestParingSnack(snackPairingID)
                } catch {
                    print("Error decoding feed data: \(error)")
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestDetailFeed(): \(error)")
            }
        }
    }
    
    public func requestParingDrink(_ alcoholPairingID: Int) {
        let ID = alcoholPairingID
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/pairings/\(ID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    print("DetailFeedViewModel.requestParingDrink(): \(data)")
                    self.pairingDrinkSubject.send(data.name ?? "")
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestParingDrink(): \(error)")
            }
        }
    }
    
    public func requestParingSnack(_ foodPairingID: Int) {
        let ID = foodPairingID
        
        NetworkWrapper.shared.getBasicTask(stringURL: "/pairings/\(ID)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(Pairings.self, from: response) {
                    print("DetailFeedViewModel.requestParingSnack(): \(data)")
                    self.pairingSnackSubject.send(data.name ?? "")
                }
            case .failure(let error):
                print("DetailFeedViewModel.requestParingSnack(): \(error)")
            }
        }
    }
    
    public func imageDatasourceCount() -> Int {
        return feedImageDatasource.count
    }
    
    var detailFeedPublisher: AnyPublisher<DetailFeed.Feed, Never> {
        return detailFeedSubject.eraseToAnyPublisher()
    }
    
    var feedImagePublisher: AnyPublisher<[String], Never> {
        return feedImageSubject.eraseToAnyPublisher()
    }
    
    var pairingDrinkPublisher: AnyPublisher<String, Never> {
        return pairingDrinkSubject.eraseToAnyPublisher()
    }
}
