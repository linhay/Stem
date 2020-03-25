// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StemCore",
    platforms: [.macOS(SupportedPlatform.MacOSVersion.v10_15)],
    products:  [.library(name: "StemCore", targets: ["Core"])],
    dependencies: [],
    targets: [.target(name: "Core", dependencies: [], path: "Sources/Core")
    ]
)
