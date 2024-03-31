//
//  String+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import Foundation

extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(count - range.lowerBound, range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "[A-Za-z0-9!@#$%^&*()_+=?~\\[\\]{}~\\.,:;<>\\/\"\'\\`|-]{8,25}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,320}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValidFormat = predicate.evaluate(with: self)
        
        if isValidFormat {
            let components = self.components(separatedBy: "@")
            
            if components[0].count > 64 {
                return false
            } else if components[1].count > 255 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

