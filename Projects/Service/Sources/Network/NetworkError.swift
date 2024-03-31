//
//  NetworkError.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import Foundation

struct NetworkError: Error, Decodable {
    var statusCode: Int? = 0
    var error: String? = ""
    var message: String? = ""
    var forbiddenWords: [String]?
    
    struct Message: Decodable {
        let error: String?
        let message: String?
    }
}

struct NetworkCommonErrors {
    private init() {}
    
    static let commonErrorMessage = "something_wrong"
    static let typeMismatchError = NetworkError(statusCode: 200, message: "Something went wrong")
}
