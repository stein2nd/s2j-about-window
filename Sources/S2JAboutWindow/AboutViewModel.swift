import Foundation
import SwiftUI

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
public class AboutViewModel: ObservableObject {
    @Published public var content: String
    @Published public var appName: String
    @Published public var version: String?
    @Published public var copyright: String?
    
    public init(
        content: String,
        appName: String? = nil,
        version: String? = nil,
        copyright: String? = nil
    ) {
        self.content = content
        self.appName = appName ?? Bundle.main.displayName ?? "App"
        self.version = version ?? Bundle.main.version
        self.copyright = copyright ?? Bundle.main.copyright
    }
    
    /// デフォルトのAboutコンテンツを読み込む
    public func loadDefaultContent() {
        guard let defaultContentPath = Bundle.module.path(forResource: "AboutDefault", ofType: "md"),
              let defaultContent = try? String(contentsOfFile: defaultContentPath) else {
            content = NSLocalizedString("About.NoDescription", bundle: .module, comment: "No description available")
            return
        }
        content = defaultContent
    }
}

// MARK: - Bundle Extensions
extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
               object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var version: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var copyright: String? {
        return object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
    }
}
#endif
