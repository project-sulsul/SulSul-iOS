//
//  Date+Extension.swift
//  DesignSystem
//
//  Created by 김유진 on 3/12/24.
//

import Foundation

public enum DateFormat: String {
    case MM월dd일 = "MM월 dd일"
    case MM_dd = "MM.dd"
    case MM월dd일요일 = "MM월 dd일 (E요일)"
}

extension Date {
    public func relativeDate(_ format: DateFormat = .MM_dd) -> String {
        // MARK: 12시간 = 12 * 60 * 60 = 43200초
        if (Date().timeIntervalSince1970 - self.timeIntervalSince1970) > 43200 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: self)
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.unitsStyle = .abbreviated
            return formatter.localizedString(for: self, relativeTo: Date())
        }
    }
}
