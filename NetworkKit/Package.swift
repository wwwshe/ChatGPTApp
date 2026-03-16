// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "NetworkKit",
            targets: ["NetworkKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "NetworkKit",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift")
            ]),
    ]
)
