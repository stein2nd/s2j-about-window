import SwiftUI
import Foundation

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
/** 
* iPadOS向けのExtensions
* @return Extensions
*/
public extension View {

    /** 
    * iPadOS向けのSheet表示用のAboutView
    * @param isPresented: 表示状態
    * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
    * @param appName: アプリ名
    * @param version: バージョン
    * @param copyright: 著作権情報
    * @return some View
    */
    func aboutSheet(isPresented: Binding<Bool>, content: String, appName: String? = nil, version: String? = nil, copyright: String? = nil) -> some View {
        self.sheet(isPresented: isPresented) {
            NavigationView {
                AboutView(
                    content: content,
                    appName: appName,
                    version: version,
                    copyright: copyright
                )
                .navigationTitle(NSLocalizedString("About.Title", bundle: Bundle.resourceBundle, comment: "About Window Title"))
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(NSLocalizedString("About.Close", bundle: Bundle.resourceBundle, comment: "Close button")) {
                            isPresented.wrappedValue = false
                        }
                    }
                }
                #endif
            }
        }
    }
    
    /** 
    * iPadOS向けのPopover表示用のAboutView
    * @param isPresented: 表示状態
    * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
    * @param appName: アプリ名
    * @param version: バージョン
    * @param copyright: 著作権情報
    * @return some View
    */
    func aboutPopover(isPresented: Binding<Bool>, content: String, appName: String? = nil, version: String? = nil, copyright: String? = nil) -> some View {
        self.popover(isPresented: isPresented) {
            AboutView(
                content: content,
                appName: appName,
                version: version,
                copyright: copyright
            )
            .frame(width: 400, height: 500)
        }
    }
}
#endif
