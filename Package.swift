// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "s2j-about-window",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "S2JAboutWindow",
            targets: ["S2JAboutWindow"]
        )
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .target(
            name: "S2JAboutWindow",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "S2JAboutWindowTests",
            dependencies: ["S2JAboutWindow"]
        )
    ]
)
