//
//  ReportViewModel.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import Foundation
import Combine
import Service
import Alamofire

enum ReportType: String {
    case feed = "feed"
    case comment = "comment"
}

enum ReportReason: String {
    case profanity = "🤬 비속어/폭언/비하/음란성 내용"
    case conflict = "🤯 갈등 조장 및 허위사실 유포"
    case spam = "🤑 도배/광고성 내용/종교 권유"
    case inappropriateNickname = "😱 부적절한 닉네임 사용"
    case other = "💬 그 외 기타사유"
}

struct ReportSelectModel {
    let title: ReportReason
    var isChecked: Bool
}

final class ReportViewModel {
    
    private let reportType: ReportType
    private let targetId: Int
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    
    private var currentReportContent: String = ""
    
    private let errorSubject = PassthroughSubject<String, Never>()
    private let reportSuccess = PassthroughSubject<Void, Never>()
    private let reportReasons = CurrentValueSubject<[ReportSelectModel], Never>([.init(title: .profanity, isChecked: false),
                                                                                  .init(title: .conflict, isChecked: false),
                                                                                  .init(title: .spam, isChecked: false),
                                                                                  .init(title: .inappropriateNickname, isChecked: false),
                                                                                  .init(title: .other, isChecked: false)])
    init(reportType: ReportType, targetId: Int) {
        self.reportType = reportType
        self.targetId = targetId
    }
    
    func setReports(reason: String, type: ReportType, targetId: Int) {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        
        let params: [String: Any] = ["reason": reason,
                                     "type": type.rawValue,
                                     "target_id": targetId]
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        NetworkWrapper.shared.postBasicTask(stringURL: "/reports", parameters: params, header: headers) { [weak self] result in
            switch result {
            case .success(let response):
                self?.reportSuccess.send(())
            case .failure(let error):
                self?.errorSubject.send(error.localizedDescription)
            }
            
        }
    }
    
    func selectReason(of index: Int) {
        guard index < reportReasons.value.count else { return }
        var changedSignOutReasons = reportReasons.value
        
        for subIndex in 0..<changedSignOutReasons.count {
            changedSignOutReasons[subIndex].isChecked = false
        }
        
        changedSignOutReasons[index].isChecked = true
        reportReasons.value = changedSignOutReasons
        
        currentReportContent = changedSignOutReasons[index].title.rawValue
    }
    
    func reportSuccessPublisher() -> AnyPublisher<Void, Never> {
        return reportSuccess.eraseToAnyPublisher()
    }
    
    func reportListCount() -> Int {
        return reportReasons.value.count
    }
    
    func getReportList() -> [ReportSelectModel] {
        return reportReasons.value
    }
    
    func reportReasonsPublisher() -> AnyPublisher<[ReportSelectModel], Never> {
        return reportReasons.eraseToAnyPublisher()
    }
    
    func getErrorSubject() -> AnyPublisher<String, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    func sendReportContent() {
        print(currentReportContent)
        setReports(reason: currentReportContent, type: self.reportType, targetId: self.targetId)
    }
    
    func currentReportContentValue() -> String {
        return currentReportContent
    }
    
    func setCurrentReportContent(_ content: String) {
        currentReportContent = content
    }
}

