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
                     preference: UserInfoModel.Preference.init(alcohols: [0],
                                                               foods: [0]),
                     status: userModel.status ?? "")
    }
}
