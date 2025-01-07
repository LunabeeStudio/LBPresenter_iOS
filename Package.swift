// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LBPresenter",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "LBPresenter",
            targets: ["LBPresenter"]),
    ],
    dependencies: [
        // Add any dependencies here
    ],
    targets: [
        .target(
            name: "LBPresenter",
            dependencies: []
        )
    ],
    swiftLanguageModes: [.v6]
)
