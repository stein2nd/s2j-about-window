// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "s2j-about-window",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
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
