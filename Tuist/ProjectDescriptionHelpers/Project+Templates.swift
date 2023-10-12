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
        name:String,
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        sources: ProjectDescription.SourceFilesList? = nil,
        scripts: [TargetScript] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return self.testProject(
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
    
    public static func topApp(
        name: Module,
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        sources: ProjectDescription.SourceFilesList? = nil,
        scripts: [TargetScript] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return self.topFeatureProject(
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
    
    public static func app2(
        name: Module,
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        sources: ProjectDescription.SourceFilesList? = nil,
        scripts: [TargetScript] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return self.featureProject(
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
                )
            ],
            schemes: schemes
        )
    }
    
    public static func featureProject(
            name: Module,
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
                name: name.name,
                targets: [
                    Target(
                        name: "\(name.name)",
                        platform: .iOS,
                        product: .framework,
                        bundleId: "\(bundleID).\(name)",
                        deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                        infoPlist: infoPlist,
                        sources: sources,
                        resources: resources,
                        scripts: scripts,
                        dependencies: dependencies
                    ),

                    Target(
                        name: "\(name.name)App",
                        platform: .iOS,
                        product: .app,
                        bundleId: "\(bundleID).\(name.name)App",
                        deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                        infoPlist: .extendingDefault(with: [
                            "UILaunchStoryboardName": "LaunchScreen",
                            "UIApplicationSceneManifest": .dictionary(
                                [
                                    "UIApplicationSupportsMultipleScenes": false,
                                    "UISceneConfigurations": [
                                        "UIWindowSceneSessionRoleApplication": [
                                            [
                                                "UISceneConfigurationName": "Default Configuration",
                                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                            ],
                                        ]
                                    ]
                                ]
                            )
                        ]
                                                    ), //Target test info plist 이름 변경 필요
                        sources: ["\(name.name)App/Sources/**"],
                        resources: ["\(name.name)App/Resources/**"],
                        scripts: scripts,
                        dependencies: [name.project]
//                        dependencies: [
                    )
                ],
                schemes: schemes
            )
        }
    
    public static func testProject(
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
    
    public static func topFeatureProject(
        name: Module,
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
            name: name.name,
            targets: [
                Target(
                    name: "\(name.name)",
                    platform: .iOS,
                    product: .framework,
                    bundleId: "\(bundleID).\(name)",
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                    infoPlist: infoPlist,
                    sources: sources,
                    resources: resources,
                    scripts: scripts,
                    dependencies: dependencies
                ),
                
                Target(
                    name: "\(name.name)App",
                    platform: .iOS,
                    product: .app,
                    bundleId: "\(bundleID).\(name.name)App",
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                    infoPlist: .extendingDefault(with: [
                        "UILaunchStoryboardName": "LaunchScreen",
                        "UIApplicationSceneManifest": .dictionary(
                            [
                                "UIApplicationSupportsMultipleScenes": false,
                                "UISceneConfigurations": [
                                    "UIWindowSceneSessionRoleApplication": [
                                        [
                                            "UISceneConfigurationName": "Default Configuration",
                                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                        ],
                                    ]
                                ]
                            ]
                        )
                    ]
                                                ), //Target test info plist 이름 변경 필요
                    sources: ["\(name.name)App/Sources/**"],
                    resources: ["\(name.name)App/Resources/**"],
                    scripts: scripts,
                    dependencies: [name.project]
                ),
                
                Target(
                    name: "\(name.name)App-test",
                    platform: .iOS,
                    product: .app,
                    bundleId: "\(bundleID).\(name.name)App-test",
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
                    infoPlist: .extendingDefault(with: [
                        "UILaunchStoryboardName": "LaunchScreen",
                        "UIApplicationSceneManifest": .dictionary(
                            [
                                "UIApplicationSupportsMultipleScenes": false,
                                "UISceneConfigurations": [
                                    "UIWindowSceneSessionRoleApplication": [
                                        [
                                            "UISceneConfigurationName": "Default Configuration",
                                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                        ],
                                    ]
                                ]
                            ]
                        )
                    ]
                                                ),
                    sources: sources, //bumjun: 이 부분 다르게 하면 소스 다르게 설정할 수 있음
                    resources: resources,
                    scripts: scripts,
                    dependencies: [name.project]
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

