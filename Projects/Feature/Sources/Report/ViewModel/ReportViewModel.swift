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

final class ReportViewModel {
    
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    private let accessToken = KeychainStore.shared.read(label: "accessToken")
    
    private let reportList: [String] = ["🤬 비속어/폭언/비하/음란성 내용",
                                        "🤯 갈등 조장 및 허위사실 유포",
                                        "🤑 도배/광고성 내용/종교 권유",
                                        "😱 부적절한 닉네임 사용",
                                        "💬 그 외 기타사유"]
    
    init() {
        
    }
    // TODO: - 신고 완료 시 api 호출 -> (피드 아이디 없어서 연동 아직 X)
    private func setReports(reason: String, type: String, targetId: Int) {
        let params: [String: Any] = ["reason": reason,
                                     "type": type,
                                     "target_id": targetId]
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken!
        ]
        NetworkWrapper.shared.postBasicTask(stringURL: "/reports", parameters: params, header: headers) {[weak self] result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func reportListCount() -> Int {
        return reportList.count
    }
    
    func getReportList(_ index: Int) -> String {
        return reportList[index]
    }
}
