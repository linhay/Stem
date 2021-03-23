// swift-tools-version:5.3
import PackageDescription

let StemCrossPlatform = "StemCrossPlatform"
let StemCore = "StemCore"
let Stem = "Stem"
let StemUIKit = "StemUIKit"
let StemSTKit = "StemSTKit"
let Static = "Static"

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v11), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: StemCore, targets: [StemCore]),
        .library(name: StemCrossPlatform, targets: [StemCrossPlatform]),
        .library(name: StemUIKit, targets: [StemUIKit]),
        .library(name: StemSTKit, targets: [StemSTKit]),
        .library(name: Stem, targets: [Stem]),
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
        
        .target(name: StemUIKit,
                dependencies: [
                    .target(name: StemCrossPlatform)
                ],
                path: "",
                sources: ["UIKit",
                          "ExportedImport/ImportStemUIKit.swift"]),
        
        .target(name: StemSTKit,
                dependencies: [
                    .target(name: StemUIKit)
                ],
                path: "",
                sources: ["STUIKit",
                          "ExportedImport/ImportStemSTKit.swift"]),
        
        .target(name: Stem,
                dependencies: [
                    .target(name: StemSTKit)
                ],
                path: "",
                sources: ["ExportedImport/ImportStem.swift"]),
    ]
)
