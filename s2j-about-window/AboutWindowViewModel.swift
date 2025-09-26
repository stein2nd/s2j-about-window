import Foundation
import Combine
import AppKit

@MainActor
/// アバウトウインドウ用 ViewModel（MVVMパターン）
final class AboutWindowViewModel: ObservableObject {
    // アプリアイコン
    @Published var appIcon: NSImage? = nil
    // アプリ名
    @Published var appName: String = ""
    // バージョン情報
    @Published var versionString: String = ""
    // 著作権
    @Published var copyright: String = ""
    // ライセンス情報
    @Published var licenseText: String = ""

    init() {
        loadAppInfo()
        loadLicense()
    }

    private func loadAppInfo() {
        let bundle = Bundle.main
        // アイコン
        if let icons = bundle.infoDictionary?["CFBundleIconFile"] as? String,
            let icon = NSImage(named: icons) {
            appIcon = icon
        } else if let iconsArray = bundle.infoDictionary?["CFBundleIconFiles"] as? [String],
                  let icon = iconsArray.last,
                  let nsIcon = NSImage(named: icon) {
            appIcon = nsIcon
        }
        // アプリ名
        appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "App"
        // バージョン
        let shortVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        versionString = "Version \(shortVersion) (\(build))"
        // 著作権
        copyright = bundle.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
    }

    private func loadLicense() {
        // デフォルトでは空文字。後でバンドル内ライセンスファイル等を読む実装に差し替え可能。
        licenseText = NSLocalizedString("LICENSE_PLACEHOLDER", comment: "デフォルトのライセンス表示")
    }
}

