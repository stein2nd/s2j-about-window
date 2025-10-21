import SwiftUI
import AppKit

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
public class AboutWindow {
    private var window: NSWindow?
    
    public init() {}
    
    /// macOS向けのAbout Windowを表示
    /// - Parameters:
    ///   - content: 表示するコンテンツ（Markdown、JSON、RTF）
    ///   - appName: アプリ名
    ///   - version: バージョン
    ///   - copyright: 著作権情報
    public func showAboutWindow(
        content: String,
        appName: String? = nil,
        version: String? = nil,
        copyright: String? = nil
    ) {
        #if os(macOS)
        let hostingController = NSHostingController(
            rootView: AboutView(
                content: content,
                appName: appName,
                version: version,
                copyright: copyright
            )
        )
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 500),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = NSLocalizedString("About.Title", bundle: .module, comment: "About Window Title")
        window.contentViewController = hostingController
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        self.window = window
        #endif
    }
    
    /// ウィンドウを閉じる
    public func closeWindow() {
        #if os(macOS)
        window?.close()
        window = nil
        #endif
    }
}
#endif
