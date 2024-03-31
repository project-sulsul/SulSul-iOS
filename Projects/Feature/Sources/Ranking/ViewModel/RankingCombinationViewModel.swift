//
//  RankingCombinationViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Combine
import Foundation
import Service

final class RankingCombinationViewModel {
    private let jsonDecoder = JSONDecoder()
    
    private var cancelBag = Set<AnyCancellable>()
    private var rankingCombinationSubject = PassthroughSubject<[Ranking], Never>()
    private var combinationDatasource: [Ranking] = []
    
    init() {}
    
    public func requestRankingCombination() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/ranks/combinations") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let data = try? self.jsonDecoder.decode(Ranking.self, from: response) {
                    self.combinationDatasource = [data]
                    self.rankingCombinationSubject.send(self.combinationDatasource)
                }
            case .failure(let error):
                print("RankingCombinationViewModel.requestRankingCombination(): \(error)")
            }
        }
    }
    
    public func combinationDatasourceCount() -> Int {
        return combinationDatasource.first?.ranking?.count ?? 0
    }
    
    public func getCombinationDatasource(to index: IndexPath) -> RankingItem? {
        return combinationDatasource.first?.ranking?[index.item]
    }
    
    public var rankingCombinationPublisher: AnyPublisher<[Ranking], Never> {
        return rankingCombinationSubject.eraseToAnyPublisher()
    }
}
