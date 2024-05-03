// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InAppTools",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "InAppTools",
            targets: ["InAppTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "3.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "InAppTools", 
            resources: [.copy("PrivacyInfo.xcprivacy")]),
        .testTarget(
            name: "InAppToolsTests",
            dependencies: ["InAppTools", "Mocker"]),
    ],
    swiftLanguageVersions: [.v5]
)
