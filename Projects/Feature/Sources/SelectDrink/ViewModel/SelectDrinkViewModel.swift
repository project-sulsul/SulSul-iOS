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

final class SelectDrinkViewModel {
    
    private let userId = UserDefaultsUtil.shared.getInstallationId()
    private let accessToken = KeychainStore.shared.read(label: "accessToken")
    private var userInfo: UserInfoModel?
    
    private let jsonDecoder = JSONDecoder()
    private let mapper = PairingModelMapper()
    private let userMapper = UserMapper()
    private var cancelBag = Set<AnyCancellable>()
    private var dataSource = [SnackModel]()
    
    private var currentSelectedDrink = PassthroughSubject<Int, Never>()
    private var setCompletedDrinkData = PassthroughSubject<Void, Never>()
    
    private var setUserDrinkPreference = PassthroughSubject<Void, Never>()
    private var completeDrinkPreference = PassthroughSubject<Void, Never>()
    
    init() {
        bind()
    }
    
    func bind() {
        getUserInfo()
        
        sendPairingsValue()
        
        setUserDrinkPreference
            .sink { [weak self] _ in
                guard let self = self else { return }
                let selectedIds = dataSource.filter { $0.isSelect }.map { $0.id }
                let params: [String: Any] = ["alcohols": selectedIds,
                                             "foods": userInfo?.preference.foods]
                var headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer " + accessToken!
                ]
                
                NetworkWrapper.shared.putBasicTask(stringURL: "/users/\(userId)/preference", parameters: params, header: headers) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let userData = try? self?.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
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
    func sendPairingsValue() {
        if let encodedURL = "/pairings?type=술".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { result in
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? self.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        let mappedData = self.mapper.snackModel(from: pairingsData.pairings ?? [])
                        self.dataSource = mappedData
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
    
    private func getUserInfo() {
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(userId)") { [weak self] result in
            switch result {
            case .success(let response):
                if let userData = try? self?.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    let mappedUserInfo = self?.userMapper.userInfoModel(from: userData)
                    self?.userInfo = mappedUserInfo
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
}
