import S2JAboutWindow
import SwiftUI

// MARK: - Sample App Entry Point

// This file demonstrates how to use S2JAboutWindow in a real application

#if os(macOS)
    @main
    struct SampleApp: App {
        private let aboutWindow = AboutWindow()

        var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .commands {
                CommandGroup(replacing: .appInfo) {
                    Button("About Sample App") {
                        aboutWindow.showAboutWindow(
                            content: """
                            # Sample App

                            This is a sample application demonstrating S2JAboutWindow.

                            ## Features
                            - Cross-platform support
                            - SwiftUI native
                            - Markdown content support
                            - Localization ready

                            ## Usage
                            This library provides an easy way to show about windows
                            in your macOS and iPadOS applications.
                            """,
                            appName: "Sample App",
                            version: "1.0.0",
                            copyright: "© 2024 Sample Company",
                            licenseResourceName: "LICENSE"
                        )
                    }
                }
            }
        }
    }
#endif

#if os(iOS)
    @main
    struct SampleApp: App {
        @State private var showAbout = false

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .aboutSheet(
                        isPresented: $showAbout,
                        content: """
                        # Sample App

                        This is a sample application demonstrating S2JAboutWindow.

                        ## Features
                        - Cross-platform support
                        - SwiftUI native
                        - Markdown content support
                        - Localization ready
                        """,
                        appName: "Sample App",
                        version: "1.0.0",
                        copyright: "© 2024 Sample Company",
                        licenseResourceName: "LICENSE"
                    )
            }
        }
    }
#endif

struct ContentView: View {
    @State private var showAbout = false

    var body: some View {
        VStack(spacing: 20) {
            Text("S2J About Window Sample")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("This is a sample application demonstrating the S2JAboutWindow library.")
                .multilineTextAlignment(.center)
                .padding()

            Button("Show About Window") {
                showAbout = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            #if os(iOS)
                Button("Show About Popover") {
                    showAbout = true
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            #endif
        }
        .padding()
        .aboutSheet(
            isPresented: $showAbout,
            content: """
            # Sample App

            This is a sample application demonstrating S2JAboutWindow.

            ## Features
            - Cross-platform support
            - SwiftUI native
            - Markdown content support
            - Localization ready

            ## Usage
            This library provides an easy way to show about windows
            in your macOS and iPadOS applications.
            """,
            appName: "Sample App",
            version: "1.0.0",
            copyright: "© 2024 Sample Company"
        )
    }
}
