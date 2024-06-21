//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: Module.feature.name,
                                packages: [.remote(url: "https://github.com/google/GoogleSignIn-iOS",
                                                   requirement: .upToNextMajor(from: "7.0.0")),
                                           .remote(url: "https://github.com/mikaoj/BSImagePicker",
                                                   requirement: .upToNextMajor(from: "3.3.2"))
                                ],
                                dependencies: [Module.service.project,
                                               Module.designSystem.project,
                                               .package(product: "BSImagePicker"),
                                               .package(product: "GoogleSignIn"),
                                               .package(product: "CocoaLumberjack"),
                                               .package(product: "CocoaLumberjackSwift")],
                                sources: .default,
                                scripts: [.SwiftLintShell],
                                resources: .default)
