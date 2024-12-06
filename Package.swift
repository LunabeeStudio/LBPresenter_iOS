// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "LBPresenter",
    platforms: [
        .iOS(.v13)
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
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "LBPresenterTests",
            dependencies: ["LBPresenter"],
            path: "Tests"
        ),
    ]
)
