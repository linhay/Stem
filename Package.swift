// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stem",
    platforms: [.macOS(SupportedPlatform.MacOSVersion.v10_15)],
    products:  [.library(name: "Stem", targets: ["Stem"])],
    targets: [
        .target(name: "Stem", dependencies: ["StemCore"]),
        .target(name: "StemCore", dependencies: [], path: "Sources/Core")
        .target(name: "StemNSObject", dependencies: ["StemCore"], path: "Sources/NSObject")
        .target(name: "StemFundamentals", dependencies: ["StemCore"], path: "Sources/Fundamentals")
    ]
)
