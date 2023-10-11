import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    static let bundleID = "bumjun.SulSul-iOS"
    static let iosVersion = "15.0"
    
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        sources: ProjectDescription.SourceFilesList? = nil,
        scripts: [TargetScript] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return self.project(
            name: name,
            product: .app,
            bundleID: bundleID + "\(name)",
            dependencies: dependencies,
            infoPlist: infoPlist,
            sources: sources,
            scripts: scripts,
            resources: resources
        )
    }
}

extension Project {
    public static func framework(name: String,
                                 dependencies: [TargetDependency] = [],
                                 sources: ProjectDescription.SourceFilesList? = nil,
                                 scripts: [TargetScript] = [],
                                 resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return .project(name: name,
                        product: .framework,
                        bundleID: bundleID + ".\(name)",
                        dependencies: dependencies,
                        sources: sources,
                        scripts: scripts,
                        resources: resources)
    }
    
    public static func project(
        name: String,
        product: Product,
        bundleID: String,
        schemes: [Scheme] = [],
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        sources: ProjectDescription.SourceFilesList? = nil,
        scripts: [TargetScript] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return Project(
            name: name,
            targets: [
                Target(
                    name: name,
                    platform: .iOS,
                    product: product,
                    bundleId: bundleID,
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                    infoPlist: infoPlist,
                    sources: sources,
                    resources: resources,
                    scripts: scripts,
                    dependencies: dependencies
                ),
                
                Target(
                    name: "\(name)-test",
                    platform: .iOS,
                    product: product,
                    bundleId: "\(bundleID).test",
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                    infoPlist: infoPlist, //Target test info plist 이름 변경 필요
                    sources: sources,
                    resources: resources,
                    scripts: scripts,
                    dependencies: dependencies
                )
            ],
            schemes: schemes
        )
    }
}

public extension TargetDependency {
    static let alamofire: TargetDependency = .external(name: "Alamofire")
    static let snapKit: TargetDependency = .external(name: "SnapKit")
    static let swinject: TargetDependency = .external(name: "Swinject")
    static let then: TargetDependency = .external(name: "Then")
}

