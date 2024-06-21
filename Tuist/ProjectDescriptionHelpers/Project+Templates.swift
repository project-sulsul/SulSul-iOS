import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    static let bundleID = "com.SulSul-iOS"
    static let iosVersion = "15.0"
    
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        packages: [ProjectDescription.Package] = [],
        sources: ProjectDescription.SourceFilesList? = nil,
        scripts: [TargetScript] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        settings: Settings? = nil,
        entitlements: ProjectDescription.Path? = nil
    ) -> Project {
        return self.project(
            name: name,
            product: .app,
            bundleID: bundleID,
            packages: packages,
            dependencies: dependencies,
            infoPlist: infoPlist,
            sources: sources,
            scripts: scripts,
            resources: resources,
            settings: settings,
            entitlements: entitlements
        )
    }
}

extension Project {
    public static func framework(name: String,
                                 packages: [ProjectDescription.Package] = [],
                                 dependencies: [TargetDependency] = [],
                                 sources: ProjectDescription.SourceFilesList? = nil,
                                 scripts: [TargetScript] = [],
                                 resources: ProjectDescription.ResourceFileElements? = nil,
                                 settings: Settings? = nil
    ) -> Project {
        return .project(name: name,
                        product: .staticFramework,
                        bundleID: bundleID + ".\(name)",
                        packages: packages,
                        dependencies: dependencies,
                        sources: sources,
                        scripts: scripts,
                        resources: resources,
                        settings: settings)
    }
    
    public static func project(
        name: String,
        product: Product,
        bundleID: String,
        packages: [ProjectDescription.Package] = [],
        schemes: [Scheme] = [],
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        sources: ProjectDescription.SourceFilesList? = nil,
        scripts: [TargetScript] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        settings: Settings? = nil,
        entitlements: ProjectDescription.Path? = ""
    ) -> Project {
        return Project(
            name: name,
            packages: packages,
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
                    entitlements: .file(path: entitlements ?? ""),
                    scripts: scripts,
                    dependencies: dependencies,
                    settings: settings
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
    static let kakaoSDK: TargetDependency = .external(name: "KakaoSDK")
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
    static let mantis: TargetDependency = .external(name: "Mantis")
    static let lottie: TargetDependency = .external(name: "Lottie")
}
