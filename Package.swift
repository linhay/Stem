// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v13), .macOS(.v11), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "Stem", targets: ["Stem"]),
        .library(name: "StemColor", targets: ["StemColor"]),
    ],
    targets: [
        .target(name: "Stem"),
        .target(name: "StemColor"),
        .testTarget(name: "StemTests", dependencies: ["Stem"]),
        .testTarget(name: "StemColorTests", dependencies: ["Stem", "StemColor"]),
    ]
)
