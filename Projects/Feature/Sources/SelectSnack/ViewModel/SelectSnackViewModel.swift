//
//  SelectSnackViewModel.swift
//  Feature
//
//  Created by 김유진 on 2023/12/09.
//

import Combine
import Foundation
import Service

final class SelectSnackViewModel {
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var mapper = SnackModelMapper()
    
    // MARK: Output Subject
    private lazy var setCompletedSnackData = PassthroughSubject<Void, Never>()
    private lazy var searchResultCountData = PassthroughSubject<Int, Never>()
    private lazy var initSectionModels = [SnackSectionModel]()
    private lazy var sectionModels = [SnackSectionModel]()
    private lazy var cellModels = [SnackModel]()
    
    init() {
        requestSnackList()
    }
    
    private func makeSectionModelsWith(_ snackModels: [SnackModel]) -> [SnackSectionModel] {
        guard var currentSection = snackModels.first?.subtype else { return [] }
        
        var sectionModels: [SnackSectionModel] = []
        var cellModelsOfSameSection: [SnackModel] = []
        
        snackModels.enumerated().forEach { index, snack in
            if snack.subtype == currentSection {
                cellModelsOfSameSection.append(snack)
            } else {
                let beforeCellModel = snackModels[index - 1]
                let headerModel = SnackHeader(snackHeaderTitle: beforeCellModel.subtype, snackHeaderImage: beforeCellModel.image)
                let completedSectionModel: SnackSectionModel = .init(cellModels: cellModelsOfSameSection, headerModel: headerModel)
                
                sectionModels.append(completedSectionModel)
                
                currentSection = snack.subtype
                cellModelsOfSameSection = [snack]
            }
        }
        
        return sectionModels
    }
    
    // MARK: Input Method
    func changeSelectedState(isSelect: Bool, indexPath: IndexPath) {
        var changedSectionModels = self.sectionModels
        var changedCellModels = self.cellModels
        
        let changedSectionModel = changedSectionModels[indexPath.section].cellModels[indexPath.row]
        let changedCellModelIndex = changedCellModels.firstIndex { $0.name == changedSectionModel.name } ?? 0
        
        changedSectionModels[indexPath.section].cellModels[indexPath.row].isSelect = isSelect
        changedCellModels[changedCellModelIndex].isSelect = isSelect
        
        
        sectionModels = changedSectionModels
        cellModels = changedCellModels
        print("|| 변경 값 : \(sectionModels[indexPath.section].cellModels[indexPath.row].isSelect)")
    }
    
    // MARK: Output Method
    func setWithInitSnackData() {
        sectionModels = initSectionModels
        
        sectionModels.enumerated().forEach { section, sectionModel in
            sectionModel.cellModels.enumerated().forEach { index, cellModel in
                guard let selectState = cellModels.first(where: { $0.name == cellModel.name })?.isSelect else { return }
                
                if selectState {
                    sectionModels[section].cellModels[index].isSelect = selectState
                }
            }
        }
    }
    
    func setWithSearchResult(_ searchText: String) {
        var searchResultSectionModels = initSectionModels
        
        initSectionModels.enumerated().forEach { section, sectionModel in
            sectionModel.cellModels.enumerated().forEach { index, cellModel in
                
                if cellModel.name.contains(searchText) {
                    guard let searchindex = searchResultSectionModels[section].cellModels.firstIndex(where: { $0.name == cellModel.name }),
                          let selectStatus = cellModels.first(where: { $0.name == cellModel.name })?.isSelect else { return }
                    
                    searchResultSectionModels[section].cellModels[searchindex].highlightedText = searchText
                    searchResultSectionModels[section].cellModels[searchindex].isSelect = selectStatus
                } else {
                    searchResultSectionModels[section].cellModels.removeAll(where: { $0.name == cellModel.name })
                }
            }
        }
        
        searchResultSectionModels.removeAll(where: { $0.cellModels.count == 0 })
        let serachResultCount = searchResultSectionModels.map { $0.cellModels.count }.reduce(0, +)
        searchResultCountData.send(serachResultCount)
        
        sectionModels = searchResultSectionModels
    }
    
    func snackSectionModelCount() -> Int {
        sectionModels.count
    }
    
    func snackSectionModel(in sectionIndex: Int) -> SnackSectionModel {
        return sectionModels[sectionIndex]
    }
    
    func snackCellModels() -> [SnackModel] {
        return cellModels
    }
    
    func selectedSnackCount() -> Int {
        return cellModels.filter{( $0.isSelect == true )}.count
    }
    
    func setCompletedSnackDataPublisher() -> AnyPublisher<Void, Never> {
        return setCompletedSnackData.eraseToAnyPublisher()
    }
    
    func searchResultCountDataPublisher() -> AnyPublisher<Int, Never> {
        return searchResultCountData.eraseToAnyPublisher()
    }
}

extension SelectSnackViewModel {
    private func requestSnackList() {
        if let encodedURL = "/pairings?type=안주".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            NetworkWrapper.shared.getBasicTask(stringURL: encodedURL) { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let responseData):
                    if let pairingsData = try? selfRef.jsonDecoder.decode(PairingModel.self, from: responseData) {
                        let mappedData = selfRef.mapper.snackModel(from: pairingsData.pairings ?? [])
                        
                        selfRef.initSectionModels = selfRef.makeSectionModelsWith(mappedData)
                        selfRef.sectionModels = selfRef.initSectionModels
                        selfRef.setCompletedSnackData.send(()) 
                        selfRef.cellModels = mappedData
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
