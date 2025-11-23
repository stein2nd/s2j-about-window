import SwiftUI

#if canImport(SwiftUI)
#if os(macOS)
import AppKit
#endif

#if os(iOS)
import UIKit
#endif

@available(macOS 12.0, iOS 15.0, *)
/**
* AboutView
* @return AboutView
*/
public struct AboutView: View {
    /**
    * AboutViewModel のインスタンス
    */
    @StateObject private var viewModel: AboutViewModel

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
        self._viewModel = StateObject(wrappedValue: AboutViewModel(
            content: content,
            appName: appName,
            version: version,
            copyright: copyright
        ))
    }

    /**
    * AboutView の本体
    * アプリアイコン、アプリ情報、コンテンツ表示、スペーサーを配置します。
    * デフォルトでは、400x500のサイズで、ウィンドウ背景色を使用します。
    */
    public var body: some View {
        VStack(spacing: 20) {
            // アプリアイコン
            appIconView
            
            // アプリ情報
            appInfoView
            
            // コンテンツ表示
            MarkdownView(content: viewModel.content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            
            // スペーサー
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 500)
        .background(backgroundColor)
    }

    /** 
    * アプリアイコンを表示
    * デフォルトでは、64x64のサイズで、角丸矩形で表示します。
    */
    private var appIconView: some View {
        Group {
            #if os(macOS)
            if let icon = NSApplication.shared.applicationIconImage {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray)
                    .frame(width: 64, height: 64)
            }
            #elseif os(iOS)
            if let icon = UIImage(named: "AppIcon") ?? UIImage(named: "AppIcon-60x60") {
                Image(uiImage: icon)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray)
                    .frame(width: 64, height: 64)
            }
            #endif
        }
    }

    /**
    * 背景色を取得
    * プラットフォームに応じて適切な背景色を返します。
    */
    private var backgroundColor: Color {
        #if os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #elseif os(iOS)
        return Color(UIColor.systemBackground)
        #else
        return Color.clear
        #endif
    }

    /**
    * アプリ情報を表示
    * アプリ名、バージョン、著作権情報を表示します。
    * デフォルトでは、フォントサイズがtitle2、フォントウェイトがbold、グレーで表示します。
    * バージョン、著作権情報は、サブヘッダーで表示します。
    */
    private var appInfoView: some View {
        VStack(spacing: 8) {
            Text(viewModel.appName)
                .font(.title2)
                .fontWeight(.bold)
            
            if let version = viewModel.version {
                Text("Version \(version)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let copyright = viewModel.copyright {
                Text(copyright)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#if DEBUG
@available(macOS 12.0, iOS 15.0, *)
/**
* AboutView_Previews
* @return AboutView_Previews
*/
struct AboutView_Previews: PreviewProvider {
    /**
    * AboutViewのプレビュー
    * デフォルトでは、# About This App、Sample App、1.0.0、© 2024 Sample Companyを表示します。
    */
    static var previews: some View {
        AboutView(
            content: "# About This App\n\nThis is a sample about content.",
            appName: "Sample App",
            version: "1.0.0",
            copyright: "© 2024 Sample Company"
        )
    }
}
#endif
#endif
