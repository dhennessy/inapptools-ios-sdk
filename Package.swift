// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InAppTools",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "InAppTools",
            targets: ["InAppTools"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "InAppTools"),
        .testTarget(
            name: "InAppToolsTests",
            dependencies: ["InAppTools"]),
    ],
    swiftLanguageVersions: [.v5]
)
