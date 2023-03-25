//
//  Dependencies.swift
//  ChatGPTAppManifests
//
//  Created by jun wook on 2023/03/25.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMajor(from: "6.5.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git",
                requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git",
                requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/scalessec/Toast-Swift.git",
                requirement: .upToNextMajor(from: "5.0.0")),
        .local(path: "Network")
    ],
    platforms: [.iOS]
)
