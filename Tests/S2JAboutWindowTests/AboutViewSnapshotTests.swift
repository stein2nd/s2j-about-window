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
    override func invokeTest() {
        withSnapshotTesting(record: .missing) {
            super.invokeTest()
        }
    }

    func testAboutViewSnapshot_light() {
        let view = AboutView(
            content: "# Snapshot App\n\nStable **markdown** for regression.",
            appName: "Snapshot App",
            version: "3.0.5",
            copyright: "© 2024 Snapshot Co."
        )

        #if os(macOS)
            let hosting = NSHostingView(rootView: view)
            hosting.frame = NSRect(x: 0, y: 0, width: 400, height: 500)
            hosting.layoutSubtreeIfNeeded()
            assertSnapshot(of: hosting, as: .image(precision: 0.98))
        #elseif os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .fixed(width: 400, height: 500), precision: 0.98)
            )
        #endif
    }

    func testMarkdownViewSnapshot_light() {
        let view = MarkdownView(content: """
        # About This App

        This is **sample** content with a [link](https://example.com).

        ## Features
        - One
        - Two
        """)

        #if os(macOS)
            let hosting = NSHostingView(rootView: view)
            hosting.frame = NSRect(x: 0, y: 0, width: 360, height: 280)
            hosting.layoutSubtreeIfNeeded()
            assertSnapshot(of: hosting, as: .image(precision: 0.98))
        #elseif os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .fixed(width: 360, height: 280), precision: 0.98)
            )
        #endif
    }
}
