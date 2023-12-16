//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: Module.feature.name,
//                                packages: [.remote(url: "https://github.com/google/GoogleSignIn-iOS",
//                                                   requirement: .exact("7.0.0"))
//                                ],
                                dependencies: [Module.service.project,
                                               Module.designSystem.project,
//                                               .package(product: "GoogleSignIn"),
                                               .package(product: "CocoaLumberjack"),
                                               .package(product: "CocoaLumberjackSwift")],
                                sources: .default,
                                scripts: [.SwiftLintShell],
                                resources: .default,
                                settings: .settings(base: ["OTHER_LDFLAGS": .string("-all_load")]))
