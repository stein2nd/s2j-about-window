// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "s2j-about-window",
    defaultLocalization: "en",
    platforms: [
        .macOS("15.0"),
        .iOS("18.0")
    ],
    products: [
        .library(
            name: "S2JAboutWindow",
            targets: ["S2JAboutWindow"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/gonzalezreal/textual", from: "0.5.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.10.0")
    ],
    targets: [
        .target(
            name: "S2JAboutWindow",
            dependencies: [
                .product(name: "Textual", package: "textual")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "S2JAboutWindowTests",
            dependencies: [
                "S2JAboutWindow",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "ViewInspector", package: "ViewInspector")
            ],
            resources: [.process("Resources")]
        )
    ]
)
