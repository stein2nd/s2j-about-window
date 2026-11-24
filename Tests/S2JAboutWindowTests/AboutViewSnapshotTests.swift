@testable import S2JAboutWindow
import SnapshotTesting
import SwiftUI
import XCTest

#if os(macOS)
    import AppKit
#endif

@available(macOS 15.0, iOS 18.0, *)
@MainActor
final class AboutViewSnapshotTests: XCTestCase {
    #if os(macOS)
        /// 参照 PNG は macos-26 CI で記録 (`update-snapshots` ワークフロー)。
        private static let imageSnapshot = Snapshotting<NSView, NSImage>.image(
            precision: 0.99,
            perceptualPrecision: 0.98
        )

        private func skipSnapshotsUnlessCI() throws {
            if ProcessInfo.processInfo.environment["CI"] != "true",
               ProcessInfo.processInfo.environment["FORCE_SNAPSHOT_TESTS"] != "1"
            {
                throw XCTSkip(
                    "画像スナップショットは GitHub Actions (macos-26) で検証。"
                        + " ローカルは FORCE_SNAPSHOT_TESTS=1。"
                )
            }
        }

        private func snapshotHostingView<Content: View>(
            rootView: Content,
            width: CGFloat,
            height: CGFloat
        ) -> NSHostingView<Content> {
            let hosting = NSHostingView(rootView: rootView)
            hosting.frame = NSRect(x: 0, y: 0, width: width, height: height)
            hosting.appearance = NSAppearance(named: .aqua)
            if let layer = hosting.layer {
                layer.contentsScale = 2
            }
            hosting.layoutSubtreeIfNeeded()
            return hosting
        }
    #endif
    override func invokeTest() {
        let record: SnapshotTestingConfiguration.Record = {
            if let raw = ProcessInfo.processInfo.environment["SNAPSHOT_TESTING_RECORD"],
               let mode = SnapshotTestingConfiguration.Record(rawValue: raw)
            {
                return mode
            }
            if ProcessInfo.processInfo.environment["CI"] == "true" {
                return .never
            }
            return .missing
        }()
        withSnapshotTesting(record: record) {
            super.invokeTest()
        }
    }

    func testAboutViewSnapshot_light() throws {
        #if os(macOS)
            try skipSnapshotsUnlessCI()
        #endif
        let view = AboutView(
            content: "# Snapshot App\n\nStable **markdown** for regression.",
            appName: "Snapshot App",
            version: "3.0.5",
            copyright: "© 2024 Snapshot Co."
        )

        #if os(macOS)
            let hosting = snapshotHostingView(rootView: view, width: 400, height: 500)
            assertSnapshot(of: hosting, as: Self.imageSnapshot)
        #elseif os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .fixed(width: 400, height: 500), precision: 0.98)
            )
        #endif
    }

    func testAboutViewClassicHorizontalSnapshot_light() throws {
        #if os(macOS)
            try skipSnapshotsUnlessCI()
        #endif
        let view = AboutView(
            content: "# Classic\n\nHorizontal header regression.",
            appName: "Classic App",
            version: "1.0.23",
            copyright: "© 2024 Classic Co.",
            headerOptions: AboutHeaderOptions(
                style: .classicHorizontal,
                showBuildNumber: true,
                buildNumberOverride: "4",
                primaryLinkTitle: "Website",
                primaryLinkURL: URL(string: "https://example.com")
            )
        )

        #if os(macOS)
            let hosting = snapshotHostingView(rootView: view, width: 480, height: 520)
            assertSnapshot(of: hosting, as: Self.imageSnapshot)
        #elseif os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .fixed(width: 480, height: 520), precision: 0.98)
            )
        #endif
    }

    func testMarkdownViewSnapshot_light() throws {
        #if os(macOS)
            try skipSnapshotsUnlessCI()
        #endif
        let view = MarkdownView(content: """
        # About This App

        This is **sample** content with a [link](https://example.com).

        ## Features
        - One
        - Two
        """)

        #if os(macOS)
            let hosting = snapshotHostingView(rootView: view, width: 360, height: 280)
            assertSnapshot(of: hosting, as: Self.imageSnapshot)
        #elseif os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .fixed(width: 360, height: 280), precision: 0.98)
            )
        #endif
    }
}
