//
//  SearchViewModel.swift
//  Feature
//
//  Created by 김유진 on 2024/01/15.
//

import Foundation
import Combine
import DesignSystem
import Service

final class SearchViewModel {
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var mapper = PairingModelMapper()
    
    private lazy var searchKeywordList: [String] = []
    private lazy var drinkList: [Pairing] = []
    private lazy var snackList: [Pairing] = []
    
    private lazy var reloadCollectionViewSubject = PassthroughSubject<Void, Never>()
    
    init() {
        getPairings()
    }
    
    func search(text: String?) -> (drink: [Pairing], snack: [Pairing]) {
        if let searchText = text {
            let drinkSearchResult = drinkList.filter({ $0.subtype?.contains(searchText) == true })
            let snackSearchResult = snackList.filter({ $0.subtype?.contains(searchText) == true })
            
            return (drinkSearchResult, snackSearchResult)
        }
        
        return ([], [])
    }
    
    func searchKeywords() -> [String] {
        return UserDefaultsUtil.shared.recentKeywordList() ?? []
    }
    
    func searchKeyword(_ index: Int) -> String {
        return searchKeywords()[index]
    }
    
    func removeSelectedKeyword(_ indexPath: IndexPath) {
        var updatedKeywords = searchKeywords()
        updatedKeywords.remove(at: indexPath.row)
        
        UserDefaultsUtil.shared.remove(key: .recentKeyword)
        UserDefaultsUtil.shared.setRecentKeywordList(updatedKeywords)
        
        reloadCollectionViewSubject.send(())
    }
    
    // MARK: Output Method
    func reloadCollectionViewPublisher() -> AnyPublisher<Void, Never> {
        return reloadCollectionViewSubject.eraseToAnyPublisher()
    }
    
    func keywordCount() -> Int {
        return searchKeywords().count
    }
}

extension SearchViewModel {
    func getPairings() {
        if let encodedURL = "/pairings?type=전체".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? selfRef.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        let mappedData = selfRef.mapper.pairingModel(from: pairingsData.pairings ?? [])
                        
                        selfRef.drinkList = mappedData.filter{ $0.type == "술" }
                        selfRef.snackList = mappedData.filter{ $0.type == "안주" }
                    } else {
                        print("[/pairings] Fail Decode")
                    }
                case .failure(let error):
                    print("[/pairings] Fail : \(error)")
                }
            }
        }
    }
}
