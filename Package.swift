// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v13), .macOS(.v11), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "Stem", targets: ["Stem"])
    ],
    targets: [
        .target(name: "Stem"),
        .testTarget(name: "StemTests", dependencies: ["Stem"])
    ]
)
