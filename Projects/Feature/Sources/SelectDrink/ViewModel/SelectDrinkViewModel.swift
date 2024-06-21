//
//  SelectDrinkViewModel.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import Foundation
import Combine
import Service
import Alamofire

enum PairingType: String {
    case drink = "술"
    case snack = "안주"
}

final class SelectDrinkViewModel {
    
    private let userId = UserDefaultsUtil.shared.getInstallationId()
    private let accessToken = KeychainStore.shared.read(label: "accessToken")
    
    private let jsonDecoder = JSONDecoder()
    private let mapper = PairingModelMapper()
    private let userMapper = UserMapper()
    private var cancelBag = Set<AnyCancellable>()
    private var dataSource = [SnackModel]()
    
    private var currentSelectedDrink = PassthroughSubject<Int, Never>()
    private var setCompletedDrinkData = PassthroughSubject<Void, Never>()
    
    private var setUserDrinkPreference = PassthroughSubject<Void, Never>()
    private var completeDrinkPreference = PassthroughSubject<Void, Never>()
    
    private let userInfo = CurrentValueSubject<UserInfoModel, Never>(.init(id: 0,
                                                                           uid: "",
                                                                           nickname: "",
                                                                           image: "",
                                                                           preference: .init(alcohols: [],
                                                                                             foods: []),
                                                                           status: ""))
    
    init() {
        bind()
    }
    
    func bind() {
        setUserDrinkPreference
            .sink { [weak self] _ in
                guard let self = self else { return }
                let selectedIds = dataSource.filter { $0.isSelect }.map { $0.id }
                let params: [String: Any] = ["alcohols": selectedIds,
                                             "foods": userInfo.value.preference.foods]
                var headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer " + accessToken!
                ]
                NetworkWrapper.shared.putBasicTask(stringURL: "/users/\(userId)/preference", parameters: params, header: headers) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let userData = try? self?.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                            self?.getUserInfo()
                            self?.completeDrinkPreference.send(())
                        } else {
                            print("Decoding failed.")
                        }
                    case.failure(let error):
                        print(error)
                    }
                }
            }.store(in: &cancelBag)
    }
    // 술 목록 가져오기
    func sendPairingsValue(_ pairingType: PairingType) {
        if let encodedURL = "/pairings?type=\(pairingType.rawValue)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        let mappedData = self.mapper.snackModel(from: pairingsData.pairings ?? [])
                        self.dataSource = mappedData
                        for id in self.userInfo.value.preference.alcohols {
                            if let index = self.dataSource.firstIndex(where: { $0.id == id }) {
                                self.selectDataSource(index)
                            }
                        }
                        self.setCompletedDrinkData.send(())
                    } else {
                        print("디코딩 모델 에러8")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func getUserInfo() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(UserDefaultsUtil.shared.getInstallationId())") { [weak self] result in
            switch result {
            case .success(let response):
                if let userData = try? self?.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    guard let mappedUserInfo = self?.userMapper.userInfoModel(from: userData) else { return }
                    self?.userInfo.send(mappedUserInfo)
                } else {
                    print("디코딩 모델 에러 9")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    // 술 취향 설정
    func sendSetUserDrinkPreference() {
        setUserDrinkPreference.send(())
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
    
    func completeDrinkPreferencePublisher() -> AnyPublisher<Void, Never> {
        return completeDrinkPreference.eraseToAnyPublisher()
    }
    
    func userInfoPublisher() -> AnyPublisher<UserInfoModel, Never> {
        return userInfo.eraseToAnyPublisher()
    }
}
