//
//  AddSnackViewModel.swift
//  Feature
//
//  Created by 김유진 on 2024/01/03.
//

import Combine
import Foundation
import Service

final class AddSnackViewModel {
    private lazy var jsonDecoder = JSONDecoder()
    private let userMapper = UserMapper()
    
    // MARK: Output
    private lazy var shouldPop = PassthroughSubject<Void, Never>()
    private lazy var updateSelectedSnackSort = PassthroughSubject<String, Never>()
    private lazy var userNickName = CurrentValueSubject<String, Never>("")
    private lazy var error = CurrentValueSubject<Void, Never>(())
    private lazy var snackSortModels: [SnackSortModel] = [.init(name: "패스트푸드", isSelect: false),
                                                          .init(name: "고기류", isSelect: false),
                                                          .init(name: "생선류", isSelect: false),
                                                          .init(name: "요리류", isSelect: false),
                                                          .init(name: "면류", isSelect: false),
                                                          .init(name: "탕류", isSelect: false),
                                                          .init(name: "튀김류", isSelect: false),
                                                          .init(name: "마른안주/과일", isSelect: false)]
    
    init(userId: Int) {
        requestGETNameOf(userId)
    }
    
    // MARK: Input Method
    func toggleSelectStatus(in index: IndexPath) {
        let updatedSelection = !snackSortModels[index.row].isSelect
        
        snackSortModels.indices.forEach { snackSortModels[$0].isSelect = false }
        snackSortModels[index.row].isSelect = updatedSelection
    }
    
    func submitAddedSnack(_ name: String, _ sort: String?) {
        requestPOSTaddSnack(.init(type: "안주", subtype: sort ?? "", name: name))
    }
    
    func sendUpdateSelectedSnackSort() {
        let selectedSnackSort = snackSortModels.first(where: { $0.isSelect == true })?.name ?? "카테고리를 선택해주세요"
        updateSelectedSnackSort.send(selectedSnackSort)
    }
    
    // MARK: Output Method
    func snackSorts() -> [SnackSortModel] {
        return snackSortModels
    }
    
    func snackSort(in index: IndexPath) -> SnackSortModel {
        return snackSortModels[index.row]
    }
    
    func shouldPopVC() -> AnyPublisher<Void, Never> {
        return shouldPop.eraseToAnyPublisher()
    }
    
    func updateSelectedSnackSortPublisher() -> AnyPublisher<String, Never> {
        return updateSelectedSnackSort.eraseToAnyPublisher()
    }
    
    func userName() -> AnyPublisher<String, Never> {
        return userNickName.dropFirst().eraseToAnyPublisher()
    }
    
    func errorPublisher() -> AnyPublisher<Void, Never> {
        return error.dropFirst().eraseToAnyPublisher()
    }
}

extension AddSnackViewModel {
    private func requestPOSTaddSnack(_ requestModel: AddSnackRequestModel) {
        var parameters: [String: Any] = [:]
        parameters["type"] = requestModel.type
        parameters["subtype"] = requestModel.subtype
        parameters["name"] = requestModel.name

        NetworkWrapper.shared.postBasicTask(stringURL: "/pairings/requests", parameters: parameters) { [weak self] result in
            switch result {
            case .success(let responseData):
                self?.shouldPop.send(())
            case .failure(_):
                self?.error.send(())
                print("[/pairings/requests] Fail")
            }
        }
    }
    
    private func requestGETNameOf(_ id: Int) {
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(id)") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseData):
                if let userData = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: responseData) {
                    guard let nickname = userData.nickname else { return }
                    self.userNickName.send(nickname)
                } else {
                    self.error.send(())
                    print("[/users/id] Fail Decode")
                }
            case .failure(let error):
                self.error.send(())
                print("[/users/id] Fail : \(error)")
            }
        }
    }
}
