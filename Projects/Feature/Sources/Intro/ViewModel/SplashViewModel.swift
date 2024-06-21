//
//  SplashViewModel.swift
//  Feature
//
//  Created by 이범준 on 3/23/24.
//

import Foundation
import Combine
import Service
import Alamofire

final class SplashViewModel {
    private var cancelBag = Set<AnyCancellable>()
    private let jsonDecoder = JSONDecoder()
    private let mapper = PairingModelMapper()
    private let drinkPairings = PassthroughSubject<Void, Never>()
    private let snackPairings = PassthroughSubject<Void, Never>()
    private let splashIsCompleted = PassthroughSubject<Void, Never>()
    
    init() {
        bind()
    }
    
    private func bind() {
        drinkPairings
            .combineLatest(snackPairings)
            .sink { [weak self] _, _ in
                guard let self = self else { return }
                
                splashIsCompleted.send(())
            }.store(in: &cancelBag)
        
        sendPairingsValue(PairingType.drink)
        sendPairingsValue(PairingType.snack)
    }
    
    private func sendPairingsValue(_ pairingType: PairingType) {
        if let encodedURL = "/pairings?type=\(pairingType.rawValue)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        let mappedData = self.mapper.snackModel(from: pairingsData.pairings ?? [])
                        if pairingType == .drink {
                            StaticValues.drinkPairings = mappedData
                            self.drinkPairings.send(())
                        } else {
                            StaticValues.snackPairings = mappedData
                            self.snackPairings.send(())
                        }
                    } else {
                        print("디코딩 모델 에러8")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func splashIsCompletedPublisher() -> AnyPublisher<Void, Never> {
        return splashIsCompleted.eraseToAnyPublisher()
    }
    
}
