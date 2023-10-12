//
//  ProjectName.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription

public enum Module {
    case sulsul
    case loginFeature
    case signUpFeature
    case core
    case ui
    case network
    case utils
    case thirdParty
}

extension Module {
    
    public var name: String {
        switch self {
        case .sulsul:
            return "SulSul"
        case .loginFeature:
            return "LoginFeature"
        case .signUpFeature:
            return "SignUpFeature"
        case .core:
            return "Core"
        case .ui:
            return "UI"
        case .network:
            return "Network"
        case .utils:
            return "Utils"
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
    
//    public var featureProject: TargetDependency {
//        return .project(target: self.name, path: self.path)
//    }
}

extension Module: CaseIterable { }
