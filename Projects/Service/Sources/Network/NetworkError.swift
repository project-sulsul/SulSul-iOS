//
//  NetworkError.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import Foundation

public extension Error {
    func getErrorMessage() -> String? {
        return (self as? NetworkError)?.message
    }
    
    func getErrorCode() -> Int? {
        return (self as? NetworkError)?.statusCode
    }
}

public struct NetworkError: Error, Decodable {
    var statusCode: Int? = 0
    var error: String? = ""
    var message: String? = ""
    
    public init(statusCode: Int? = nil, error: String? = nil, message: String? = nil) {
        self.statusCode = statusCode
        self.error = error
        self.message = message
    }
}

struct NetworkCommonErrors {
    private init() {}
    
    static let commonErrorMessage = "something_wrong"
    static let typeMismatchError = NetworkError(statusCode: 200, message: "Something went wrong")
}
