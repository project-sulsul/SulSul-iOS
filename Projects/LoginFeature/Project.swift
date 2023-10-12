//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/10/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app2(name: Module.loginFeature,
                           dependencies: [Module.core.project, Module.ui.project],
                           sources: .default,
                           resources: .default)
