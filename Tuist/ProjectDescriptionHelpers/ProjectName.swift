//
//  ProjectName.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription

public enum Module {
    case app
    case designSystem
//    case designSystemApp
    case feature
    case service
    case thirdParty
}

extension Module {
    
    public var name: String {
        switch self {
        case .app:
            return "App"
        case .designSystem:
            return "DesignSystem"
//        case .designSystemApp:
//            return "DesignSystemApp"
        case .feature:
            return "Feature"
        case .service:
            return "Service"
        case .thirdParty:
            return "ThirdParty"
        }
    }
    
    public var path: ProjectDescription.Path {
        return .relativeToRoot("Projects/" + self.name)
    }
    
    public var project: TargetDependency {
        return .project(target: self.name, path: self.path)
    }
}

extension Module: CaseIterable { }
