// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stem",
    products: [
        .library(
            name: "Stem",
            targets: ["Stem"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Stem",
            path: "Sources",
            dependencies: [])
    ]
)
