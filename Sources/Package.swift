// swift-tools-version:5.3
import PackageDescription

let StemCrossPlatform = "StemCrossPlatform"
let StemCore = "StemCore"
let Stem = "Stem"
let Static = "Static"

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v11), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: StemCrossPlatform, targets: [StemCrossPlatform]),
        .library(name: StemCore, targets: [StemCore]),
        .library(name: Stem, targets: [Stem]),
        
        .library(name: StemCrossPlatform + Static, type: .static, targets: [StemCrossPlatform]),
        .library(name: StemCore + Static, type: .static, targets: [StemCore]),
        .library(name: Stem + Static, type: .static, targets: [Stem]),
    ],
    targets: [
        .target(name: StemCore,
                path: "",
                sources: ["Core"]),
        .target(name: StemCrossPlatform,
                dependencies: [
                    .target(name: StemCore)
                ],
                path: "",
                sources: ["CrossPlatform",
                          "ExportedImport/ImportCore.swift"]),
        .target(name: Stem,
                dependencies: [
                    .target(name: StemCrossPlatform)
                ],
                path: "",
                sources: [
                    "STUIKit",
                    "UIKit",
                    "ExportedImport/ImportCrossPlatform.swift",
                ]
        )
    ]
)
