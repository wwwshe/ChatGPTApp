// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [:],
    baseSettings: .settings(base: ["SWIFT_ENABLE_EXPLICIT_MODULES": "NO"])
)
#endif

let package = Package(
    name: "ChatGPTApp",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", from: "2.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", from: "4.0.0"),
        .package(url: "https://github.com/scalessec/Toast-Swift.git", from: "5.0.0"),
        .package(path: "../NetworkKit"),
    ]
)

