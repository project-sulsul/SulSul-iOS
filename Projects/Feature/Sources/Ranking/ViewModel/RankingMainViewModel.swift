//
//  RankingMainViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import Foundation
import Service

final class RankingMainViewModel {
    private let jsonDecoder = JSONDecoder()
    
    private var cancelBag = Set<AnyCancellable>()
    private var dateSubject = PassthroughSubject<RankingDate, Never>()
    
    init() {}
    
    public func requestRankingDate() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/ranks/alcohol") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? jsonDecoder.decode(RankingDate.self, from: response) {
                    self.dateSubject.send(data)
                }
            case .failure(let error):
                print("RankingMainViewModel.requestRankingDate(): \(error)")
            }
        }
    }
    
    public var rankingDatePublisher: AnyPublisher<RankingDate, Never> {
        return dateSubject.eraseToAnyPublisher()
    }
}
