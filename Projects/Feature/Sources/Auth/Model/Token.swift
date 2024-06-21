//
//  Token.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-12.
//

import Foundation

struct Token: Codable {
    let userID: Int
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
