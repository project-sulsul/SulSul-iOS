//
//  RankingDrinkViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-07.
//

import Combine
import Foundation
import Service

final class RankingDrinkViewModel {
    private let jsonDecoder = JSONDecoder()
    
    private var cancelBag = Set<AnyCancellable>()
    private var rankingDrinkSubject = PassthroughSubject<[Ranking], Never>()
    private var drinkDatasource: [Ranking] = []
    
    init() {}
    
    public func requestRankingAlcohol() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/ranks/alcohol") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let data = try? self.jsonDecoder.decode(Ranking.self, from: response) {
                    print(data)
                    self.drinkDatasource = [data]
                    self.rankingDrinkSubject.send(self.drinkDatasource)
                }
            case .failure(let error):
                print("RankingDrinkViewModel.requestRankingAlcohol(): \(error)")
            }
        }
    }
    
    public func drinkDatasourceCount() -> Int {
        return drinkDatasource.first?.ranking?.count ?? 0
    }
    
    public func getDrinkDatasource(to index: IndexPath) -> RankingItem? {
        return drinkDatasource.first?.ranking?[index.item]
    }
    
    public var rankingDrinkPublisher: AnyPublisher<[Ranking], Never> {
        return rankingDrinkSubject.eraseToAnyPublisher()
    }
}
