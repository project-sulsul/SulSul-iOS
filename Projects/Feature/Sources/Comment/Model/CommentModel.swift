//
//  CommentModel.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import Foundation

struct CommentModel: Decodable {
    let comments: [Comment]
}

struct Comment: Decodable {
    let comment_id: Int
    let user_info: UserInfo
    let content: String
    let created_at: String
    let updated_at: String
    let is_reported: Bool
    let is_writer: Bool
    var children_comments: [Comment]?
    var isChildren: Bool? = false
    var parent_comment_id: Int? = 0
}

struct WriteCommentRequest {
    let feed_id: Int
    let content: String
    let parent_comment_id: Int
}

struct DeleteCommentRequest {
    let feed_id: Int
    let comment_id: Int
}

struct UserInfo: Decodable {
    let user_id: Int
    let nickname: String
    let image: String?
}
