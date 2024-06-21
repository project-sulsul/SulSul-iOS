//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: Module.app.name,
                          dependencies: [Module.feature.project,
                                         .package(product: "GoogleSignIn"),
                                         .package(product: "CocoaLumberjack"),
                                         .package(product: "CocoaLumberjackSwift")],
                          infoPlist: .file(path: "Support/Info.plist"),
                          sources: .default,
                          scripts: [.SwiftLintShell],
                          resources: .default,
                          entitlements: "App.entitlements")
