//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.topApp(name: Module.sulsul,
                          dependencies: [
                            Module.signUpFeature.project,
                            Module.loginFeature.project
                          ],
                          infoPlist: .file(path: "Support/Info.plist"), //string으로 바꾸자
                          sources: .default,
                          scripts: [.SwiftLintShell],
                          resources: .default)


//let project = Project.app(name: Module.app.name,
//                           dependencies: [Module.signUpFeature.project, Module.loginFeature.project],
//                           sources: .default,
//                           resources: .default)


// 타겟이라는게 결국은 app임
