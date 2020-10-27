// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Stem",
    platforms: [.iOS(.v10), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: "stem", targets: ["Stem"]),
        .library(name: "stem_dynamic", type: .dynamic, targets: ["Stem"]),
        .library(name: "stem_static", type: .static, targets: ["Stem"]),
        
        .library(name: "stem_crossPlatform", targets: ["Stem_CrossPlatform"]),
        .library(name: "stem_crossPlatform_dynamic", type: .dynamic, targets: ["Stem_CrossPlatform"]),
        .library(name: "stem_crossPlatform_static", type: .static, targets: ["Stem_CrossPlatform"]),
    ],
    targets: [
        .target(
            name: "Stem",
            path: "Sources",
            exclude: ["Core", 
                      "CrossPlatform",
                      "STUIKit",
                      "UIKit"]
        ),
        .target(
            name: "Stem_CrossPlatform",
            path: "Sources",
            exclude: ["Core", 
                      "CrossPlatform"]
        )
    ]
)
