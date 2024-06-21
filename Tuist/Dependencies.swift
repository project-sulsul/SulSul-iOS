//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .alamofire,
            .snapKit,
            .then,
            .swinject,
            .kingfisher,
            .mantis,
            .lottie,
            .kakaoSDK
        ],
        productTypes: [
            "Alamofire": .framework,
            "Then": .framework,
            "Kingfisher": .framework
        ]
    ),
    platforms: [.iOS]
)

public extension Package {
    static let alamofire: Package = .remote(url: "https://github.com/Alamofire/Alamofire",
                                            requirement: .upToNextMajor(from: "5.9.1"))
    static let snapKit: Package = .remote(url: "https://github.com/SnapKit/SnapKit.git",
                                          requirement: .upToNextMajor(from: "5.0.1"))
    static let then: Package = .remote(url: "https://github.com/devxoul/Then",
                                       requirement: .upToNextMajor(from: "2.7.0"))
    static let swinject: Package = .remote(url: "https://github.com/Swinject/Swinject",
                                           requirement: .upToNextMajor(from: "2.8.3"))
    static let kakaoSDK: Package = .remote(url: "https://github.com/kakao/kakao-ios-sdk",
                                           requirement: .upToNextMajor(from: "2.0.0"))
    static let kingfisher: Package = .remote(url: "https://github.com/onevcat/Kingfisher.git",
                                             requirement: .upToNextMajor(from: "7.0.0"))
    static let mantis: Package = .remote(url: "https://github.com/guoyingtao/Mantis.git", requirement: .upToNextMajor(from: "2.20.0"))
    static let lottie: Package = .remote(url: "https://github.com/airbnb/lottie-spm.git", requirement: .upToNextMajor(from: "4.4.3"))
}
