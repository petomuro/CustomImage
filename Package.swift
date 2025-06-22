// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomImage",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CustomImage",
            targets: [
                "CustomImage"
            ]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/petomuro/CachedAsyncImage", exact: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CustomImage",
            dependencies: [
                "CachedAsyncImage"
            ],
        ),
        .testTarget(
            name: "CustomImageTests",
            dependencies: [
                "CustomImage"
            ]
        )
    ]
)
