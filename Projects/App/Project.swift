//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: Module.app.name,
                          dependencies: [
                            Module.feature,
                          ].map(\.project),
                          infoPlist: .file(path: "Support/Info.plist"), //string으로 바꾸자
                          sources: .default,
                          scripts: [.SwiftLintShell],
                          resources: .default)



// 타겟이라는게 결국은 app임
