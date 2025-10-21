import SwiftUI
import S2JAboutWindow

// MARK: - Sample App Entry Point
// This file demonstrates how to use S2JAboutWindow in a real application

#if os(macOS)
@main
struct SampleApp: App {
    @StateObject private var aboutWindow = AboutWindow()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    setupMenuBar()
                }
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Sample App") {
                    showAboutWindow()
                }
            }
        }
    }
    
    private func setupMenuBar() {
        // Setup menu bar integration
        if let mainMenu = NSApplication.shared.mainMenu {
            let appMenu = mainMenu.item(at: 0)?.submenu
            appMenu?.addItem(NSMenuItem.separator())
            
            let aboutItem = NSMenuItem(
                title: "About Sample App",
                action: #selector(showAboutWindow),
                keyEquivalent: ""
            )
            aboutItem.target = self
            appMenu?.addItem(aboutItem)
        }
    }
    
    @objc private func showAboutWindow() {
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
            This library provides an easy way to show about windows in your macOS and iPadOS applications.
            """,
            appName: "Sample App",
            version: "1.0.0",
            copyright: "© 2024 Sample Company"
        )
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
                    copyright: "© 2024 Sample Company"
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
            This library provides an easy way to show about windows in your macOS and iPadOS applications.
            """,
            appName: "Sample App",
            version: "1.0.0",
            copyright: "© 2024 Sample Company"
        )
    }
}
