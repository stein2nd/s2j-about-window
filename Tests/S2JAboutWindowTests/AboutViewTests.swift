import XCTest
import SwiftUI
@testable import S2JAboutWindow

@available(macOS 12.0, iOS 15.0, *)
final class AboutViewTests: XCTestCase {
    
    func testAboutViewModelInitialization() {
        let viewModel = AboutViewModel(
            content: "Test content",
            appName: "Test App",
            version: "1.0.0",
            copyright: "© 2024 Test Company"
        )
        
        XCTAssertEqual(viewModel.content, "Test content")
        XCTAssertEqual(viewModel.appName, "Test App")
        XCTAssertEqual(viewModel.version, "1.0.0")
        XCTAssertEqual(viewModel.copyright, "© 2024 Test Company")
    }
    
    func testAboutViewModelWithNilValues() {
        let viewModel = AboutViewModel(
            content: "Test content",
            appName: nil,
            version: nil,
            copyright: nil
        )
        
        XCTAssertEqual(viewModel.content, "Test content")
        XCTAssertNotNil(viewModel.appName) // Should fallback to Bundle.main.displayName
    }
    
    func testMarkdownViewContent() {
        let markdownContent = "# Test\n\nThis is a **test** content."
        let markdownView = MarkdownView(content: markdownContent)
        
        // Basic test to ensure MarkdownView can be created
        XCTAssertNotNil(markdownView)
    }
    
    func testAboutViewCreation() {
        let aboutView = AboutView(
            content: "Test content",
            appName: "Test App",
            version: "1.0.0",
            copyright: "© 2024 Test Company"
        )
        
        XCTAssertNotNil(aboutView)
    }
    
    #if os(macOS)
    func testAboutWindowCreation() {
        let aboutWindow = AboutWindow()
        XCTAssertNotNil(aboutWindow)
    }
    #endif
    
    #if os(macOS)
    func testAboutWindowShowWindow() {
        let aboutWindow = AboutWindow()
        
        // Test that showAboutWindow doesn't crash
        aboutWindow.showAboutWindow(
            content: "Test content",
            appName: "Test App",
            version: "1.0.0",
            copyright: "© 2024 Test Company"
        )
        
        // Test that closeWindow works
        aboutWindow.closeWindow()
    }
    #endif
}

// MARK: - Snapshot Testing Support
@available(macOS 12.0, iOS 15.0, *)
extension AboutViewTests {
    
    func testAboutViewSnapshot() {
        let aboutView = AboutView(
            content: "# Test App\n\nThis is a test application.",
            appName: "Test App",
            version: "1.0.0",
            copyright: "© 2024 Test Company"
        )
        
        // Note: This test would require SnapshotTesting framework
        // For now, we just ensure the view can be created
        XCTAssertNotNil(aboutView)
    }
    
    func testMarkdownViewSnapshot() {
        let markdownView = MarkdownView(content: """
        # About This App
        
        This is a **sample** about content with *markdown* formatting.
        
        ## Features
        - Feature 1
        - Feature 2
        - Feature 3
        
        [Visit our website](https://example.com)
        """)
        
        // Note: This test would require SnapshotTesting framework
        // For now, we just ensure the view can be created
        XCTAssertNotNil(markdownView)
    }
}
