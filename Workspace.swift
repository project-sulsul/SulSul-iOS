//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(name: "SulSul",
                          projects: Module.allCases.map(\.path))

// jira 테스트
