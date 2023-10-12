//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app2(name: Module.designSystem.name,
                                dependencies: [Module.thirdParty.project],
                                sources: .default,
                                resources: .default)
