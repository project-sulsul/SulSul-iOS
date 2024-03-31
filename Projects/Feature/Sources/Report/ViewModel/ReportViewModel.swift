//
//  ReportViewModel.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import Foundation
import Combine

final class ReportViewModel {
    
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    
    private let reportList: [String] = ["🤬 비속어/폭언/비하/음란성 내용",
                                        "🤯 갈등 조장 및 허위사실 유포",
                                        "🤑 도배/광고성 내용/종교 권유",
                                        "😱 부적절한 닉네임 사용",
                                        "💬 그 외 기타사유"]
    
    init() {
        
    }
    
    func reportListCount() -> Int {
        return reportList.count
    }
    
    func getReportList(_ index: Int) -> String {
        return reportList[index]
    }
}
