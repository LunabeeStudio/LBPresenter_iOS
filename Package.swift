// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "LBPresenter",
    platforms: [
        .iOS(.v15)
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
        ),
        .testTarget(
            name: "LBPresenterTests",
            dependencies: ["LBPresenter"]
        ),
    ]
)
