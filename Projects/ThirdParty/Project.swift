//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: Module.thirdParty.name,
                                dependencies: [.swinject,
                                               .alamofire,
                                               .snapKit,
                                               .then,
                                               .kingfisher,
                                               .mantis,
                                               .kakaoSDK,
                                               .lottie])
