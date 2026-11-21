#if os(iOS)
    @testable import S2JAboutWindow
    import SwiftUI
    import ViewInspector
    import XCTest

    @available(iOS 18.0, *)
    @MainActor
    final class AboutSheetInspectorTests: XCTestCase {
        private struct Host: View {
            @State private var isPresented = true

            var body: some View {
                Color.clear
                    .aboutSheet(
                        isPresented: $isPresented,
                        content: "# Sheet\n\nInspector body",
                        appName: "SheetApp",
                        version: "2.0",
                        copyright: "© Inspector"
                    )
            }
        }

        func testAboutSheetEmbedsAboutView() throws {
            let host = Host()
            let sheet = try host.inspect().color().sheet()
            _ = try sheet.find(AboutView.self)
        }
    }
#endif
