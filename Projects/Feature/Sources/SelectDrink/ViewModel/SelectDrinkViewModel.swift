//
//  SelectDrinkViewModel.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import Foundation
import Combine
import Service

final class SelectDrinkViewModel {
    
    private let jsonDecoder = JSONDecoder()
    private let mapper = PairingModelMapper()
    private var cancelBag = Set<AnyCancellable>()
    private var dataSource = [SnackModel]()
    
    private var currentSelectedDrink = PassthroughSubject<Int, Never>()
    private var setCompletedDrinkData = PassthroughSubject<Void, Never>()
    
    init() {
        sendPairingsValue()
    }
    
    func sendPairingsValue() {
        if let encodedURL = "/pairings?type=술".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        let mappedData = self.mapper.pairingModel(from: pairingsData.pairings ?? [])
                        self.dataSource = mappedData
                        self.setCompletedDrinkData.send(())
                    } else {
                        print("디코딩 모델 에러")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func dataSourceCount() -> Int {
        return dataSource.count
    }
    
    func getDataSource(_ index: Int) -> SnackModel {
        return dataSource[index]
    }
    
    func selectDataSource(_ index: Int) {
        var selectedItemCount = dataSource.filter { $0.isSelect == true }.count
        
        if selectedItemCount < 3 {
            dataSource[index].isSelect.toggle()
            selectedItemCount += dataSource[index].isSelect ? 1 : -1
        } else {
            if dataSource[index].isSelect == true {
                dataSource[index].isSelect.toggle()
                selectedItemCount -= 1
            } else {
                currentSelectedDrink.send(999)
            }
        }
        
        currentSelectedDrink.send(selectedItemCount)
    }
    
    func currentSelectedDrinkPublisher() -> AnyPublisher<Int, Never> {
        return currentSelectedDrink.eraseToAnyPublisher()
    }
    
    func setCompletedSnackDataPublisher() -> AnyPublisher<Void, Never> {
        return setCompletedDrinkData.eraseToAnyPublisher()
    }
}
