import Foundation
import SwiftUI

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
/** 
* @return AboutViewModel
*/
public class AboutViewModel: ObservableObject {
    /**
    * @var content: 表示するコンテンツ（Markdown、JSON、RTF）
    */
    @Published public var content: String

    /**
    * @var appName: アプリ名
    */
    @Published public var appName: String

    /**
    * @var version: バージョン
    */
    @Published public var version: String?

    /**
    * @var copyright: 著作権情報
    */
    @Published public var copyright: String?

    /**
    * コンストラクタ
    * 表示するコンテンツ（Markdown、JSON、RTF）、アプリ名、バージョン、著作権情報を指定してAboutViewModelを初期化
    * デフォルトでは、Bundle.main.displayName、Bundle.main.version、Bundle.main.copyrightを使用します。
    *
    * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
    * @param appName: アプリ名
    * @param version: バージョン
    * @param copyright: 著作権情報
    */
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
    
    /**
    * デフォルトのAboutコンテンツを読み込む
    * @return void
    */
    public func loadDefaultContent() {
        guard let defaultContentPath = Bundle.resourceBundle.path(forResource: "AboutDefault", ofType: "md"),
              let defaultContent = try? String(contentsOfFile: defaultContentPath) else {
            content = NSLocalizedString("About.NoDescription", bundle: Bundle.resourceBundle, comment: "No description available")
            return
        }
        content = defaultContent
    }
}

// MARK: - Bundle Extensions
extension Bundle {
    /** 
     * @return アプリ名
     */
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
               object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    /**
     * @return バージョン
     */
    var version: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    /** 
     * @return 著作権情報
     */
    var copyright: String? {
        return object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
    }

    /**
     * モジュールの Bundle を取得
     * Swift Package Manager の場合は自動生成された Bundle.module を使用
     * Xcode プロジェクトの場合はフレームワークの Bundle を使用
     * @return Bundle
     */
    static var resourceBundle: Bundle {
        #if SWIFT_PACKAGE
        // Swift Package Manager の場合、自動生成された Bundle.module を使用
        return Bundle.module
        #else
        // Xcode プロジェクトの場合、フレームワークの Bundle を使用
        return Bundle(for: AboutViewModel.self)
        #endif
    }
}
#endif
