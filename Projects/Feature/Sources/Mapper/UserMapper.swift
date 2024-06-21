//
//  UserMapper.swift
//  Feature
//
//  Created by 이범준 on 2/8/24.
//

import Foundation

struct UserMapper {
    func userInfoModel(from userModel: RemoteUserInfoItem) -> UserInfoModel {
        return .init(id: userModel.id ?? 0,
                     uid: userModel.uid ?? "",
                     nickname: userModel.nickname ?? "",
                     image: userModel.image ?? "",
                     preference: UserInfoModel.Preference.init(alcohols: userModel.preference?.alcohols ?? [0],
                                                               foods: userModel.preference?.foods ?? [0]),
                     status: userModel.status ?? "")
    }
    
    func deleteUserModel(from userModel: RemoteDeleteUserItem) -> DeleteUserModel {
        return .init(result: userModel.result ?? false)
    }
}
