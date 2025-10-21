import SwiftUI
import Foundation

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
public extension View {
    /// iPadOS向けのSheet表示用のAboutView
    func aboutSheet(isPresented: Binding<Bool>, content: String, appName: String? = nil, version: String? = nil, copyright: String? = nil) -> some View {
        self.sheet(isPresented: isPresented) {
            NavigationView {
                AboutView(
                    content: content,
                    appName: appName,
                    version: version,
                    copyright: copyright
                )
                .navigationTitle(NSLocalizedString("About.Title", bundle: .module, comment: "About Window Title"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(NSLocalizedString("About.Close", bundle: .module, comment: "Close button")) {
                            isPresented.wrappedValue = false
                        }
                    }
                }
            }
        }
    }
    
    /// iPadOS向けのPopover表示用のAboutView
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
