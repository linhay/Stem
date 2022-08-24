// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v13), .macOS(.v11), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "Stem", targets: ["Stem"]),
        .library(name: "StemFilePath", targets: ["StemFilePath"]),
        .library(name: "StemColor", targets: ["StemColor"]),
        .library(name: "StemHybrid", targets: ["StemHybrid"]),
    ],
    targets: [
        .target(name: "Stem"),
        .target(name: "StemHybrid"),
        .target(name: "StemFilePath"),
        .target(name: "StemColor"),
        .testTarget(name: "StemTests", dependencies: ["Stem", "StemFilePath"]),
        .testTarget(name: "StemColorTests", dependencies: ["Stem", "StemColor", "StemFilePath"]),
        .testTarget(name: "StemFilePathTests", dependencies: ["Stem", "StemFilePath"]),
    ]
)
