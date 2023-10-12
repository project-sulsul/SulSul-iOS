//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/10/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: Module.utils.name,
                                dependencies: [Module.thirdParty.project],
                                sources: .default)
