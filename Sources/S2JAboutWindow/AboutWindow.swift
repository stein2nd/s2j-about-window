import SwiftUI
import AppKit

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
/** 
* @return AboutWindow
*/
public class AboutWindow {
    /**
    * @var window: NSWindow?
    */
    private var window: NSWindow?
    
    /**
    * @return AboutWindow
    */
    public init() {}
    
    /**
    * macOS向けのAbout Windowを表示
    * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
    * @param appName: アプリ名
    * @param version: バージョン
    * @param copyright: 著作権情報
    */
    public func showAboutWindow(
        content: String,
        appName: String? = nil,
        version: String? = nil,
        copyright: String? = nil
    ) {
        #if os(macOS)
        /** 
        * NSHostingControllerを作成
        * AboutViewをルートビューとして表示します。
        *
        * @var hostingController: NSHostingController
        */
        let hostingController = NSHostingController(
            rootView: AboutView(
                content: content,
                appName: appName,
                version: version,
                copyright: copyright
            )
        )
        
        /**
        * NSWindowを作成
        * AboutViewを表示します。
        * デフォルトでは、400x500のサイズで、タイトルバー、閉じるボタン、最小化ボタンを表示します。
        *
        * @var window: NSWindow
        */
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
    
    /** 
    * ウィンドウを閉じる
    * @return void
    */
    public func closeWindow() {
        #if os(macOS)
        window?.close()
        window = nil
        #endif
    }
}
#endif
