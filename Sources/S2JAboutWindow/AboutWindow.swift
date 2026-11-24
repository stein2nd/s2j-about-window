import SwiftUI

#if canImport(SwiftUI)
    #if os(macOS)
        import AppKit

        /**
         * @return AboutWindow
         */
        @available(macOS 15.0, *)
        @MainActor
        public class AboutWindow: NSObject, NSWindowDelegate {
            /**
             * @var window: NSWindow?
             */
            private var window: NSWindow?

            /**
             * @return AboutWindow
             */
            override public init() {
                super.init()
            }

            /**
             * macOS向けのAbout Windowを表示
             * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
             * @param contentType: 本文の表示形式 (デフォルト `.automatic`)
             * @param appName: アプリ名
             * @param version: バージョン
             * @param copyright: 著作権情報
             */
            public func showAboutWindow(
                content: String,
                contentType: AboutContentType = .automatic,
                appName: String? = nil,
                version: String? = nil,
                copyright: String? = nil,
                headerOptions: AboutHeaderOptions = .default,
                licenseResourceName: String? = nil,
                acknowledgementsResourceName: String? = nil,
                resourceBundle: Bundle = .main,
                contentSize: CGSize? = nil
            ) {
                #if os(macOS)
                    /*
                     * NSHostingControllerを作成
                     * AboutViewをルートビューとして表示します。
                     *
                     * @var hostingController: NSHostingController
                     */
                    let hostingController = NSHostingController(
                        rootView: AboutView(
                            content: content,
                            contentType: contentType,
                            appName: appName,
                            version: version,
                            copyright: copyright,
                            headerOptions: headerOptions,
                            licenseResourceName: licenseResourceName,
                            acknowledgementsResourceName: acknowledgementsResourceName,
                            resourceBundle: resourceBundle
                        )
                    )

                    /*
                     * NSWindowを作成
                     * AboutViewを表示します。
                     * デフォルトでは、400x500のサイズで、タイトルバー、閉じるボタン、最小化ボタンを表示します。
                     *
                     * @var window: NSWindow
                     */
                    let defaultSize = contentSize ?? CGSize(
                        width: headerOptions.style == .classicHorizontal ? 480 : 400,
                        height: 500
                    )
                    let window = NSWindow(
                        contentRect: NSRect(
                            origin: .zero,
                            size: NSSize(width: defaultSize.width, height: defaultSize.height)
                        ),
                        styleMask: [.titled, .closable, .miniaturizable],
                        backing: .buffered,
                        defer: false
                    )

                    window.title = NSLocalizedString(
                        "About.Title",
                        bundle: Bundle.resourceBundle,
                        comment: "About Window Title"
                    )
                    window.contentViewController = hostingController
                    window.center()
                    window.isReleasedWhenClosed = false
                    window.delegate = self
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

            /**
             * NSWindowDelegate: ウィンドウが閉じられる前に呼ばれる
             * @param notification: Notification
             * @return void
             */
            public func windowWillClose(_ notification: Notification) {
                #if os(macOS)
                    if let window = notification.object as? NSWindow, window == self.window {
                        self.window = nil
                    }
                #endif
            }
        }
    #endif
#endif
