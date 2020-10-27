// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v10), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: "Stem", targets: ["Stem"]),
        .library(name: "StemDynamic", type: .dynamic, targets: ["Stem"]),
        .library(name: "StemStatic", type: .static, targets: ["Stem"]),
    ],
    targets: [
        .target(
            name: "Stem",
            path: "Sources",
            exclude: ["Core", 
                      "CrossPlatform",
                      "STUIKit",
                      "UIKit"]
        )
    ]
)
