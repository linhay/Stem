// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v11), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: "Stem", targets: ["Stem"]),
    ],
    targets: [
        .target(name: "Stem",
                path: "Sources",
                sources: [
                    "Core",
                    "STUIKit",
                    "UIKit",
                    "CrossPlatform"
                ]
        )
    ]
)
