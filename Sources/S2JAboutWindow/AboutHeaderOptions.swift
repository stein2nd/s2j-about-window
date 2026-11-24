import CoreGraphics
import Foundation

/// About ヘッダーのレイアウトスタイル。
@available(macOS 15.0, iOS 18.0, *)
public enum AboutHeaderStyle: Sendable, Equatable {
    /// 現行どおり縦積み (デフォルト)。
    case vertical
    /// 左に大アイコン・右にメタ情報 (クラシック About)。
    case classicHorizontal
}

/// About ヘッダー表示オプション (opt-in。デフォルトは v3 互換)。
@available(macOS 15.0, iOS 18.0, *)
public struct AboutHeaderOptions: Sendable, Equatable {
    public var style: AboutHeaderStyle
    public var iconSideLength: CGFloat?
    public var showBuildNumber: Bool
    public var buildNumberOverride: String?
    public var supportIdentifier: String?
    public var headerAccessoryImageName: String?
    public var accessoryBundle: Bundle
    public var primaryLinkTitle: String?
    public var primaryLinkURL: URL?

    public static let `default` = AboutHeaderOptions()

    public init(
        style: AboutHeaderStyle = .vertical,
        iconSideLength: CGFloat? = nil,
        showBuildNumber: Bool = false,
        buildNumberOverride: String? = nil,
        supportIdentifier: String? = nil,
        headerAccessoryImageName: String? = nil,
        accessoryBundle: Bundle = .main,
        primaryLinkTitle: String? = nil,
        primaryLinkURL: URL? = nil
    ) {
        self.style = style
        self.iconSideLength = iconSideLength
        self.showBuildNumber = showBuildNumber
        self.buildNumberOverride = buildNumberOverride
        self.supportIdentifier = supportIdentifier
        self.headerAccessoryImageName = headerAccessoryImageName
        self.accessoryBundle = accessoryBundle
        self.primaryLinkTitle = primaryLinkTitle
        self.primaryLinkURL = primaryLinkURL
    }

    /// プライマリ外部リンク (タイトルと URL が両方あるときのみ有効)。
    public var resolvedPrimaryLink: (title: String, url: URL)? {
        guard let title = primaryLinkTitle?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty,
              let url = primaryLinkURL
        else {
            return nil
        }
        return (title, url)
    }
}

/// バージョン行の組み立て (`Version 1.0.23 (4)` 形式)。
@available(macOS 15.0, iOS 18.0, *)
enum AboutVersionDisplay {
    static func formattedLine(
        marketingVersion: String?,
        showBuildNumber: Bool,
        buildNumber: String?,
        buildNumberOverride: String?,
        versionLabel: String
    ) -> String? {
        guard let marketing = marketingVersion, !marketing.isEmpty else {
            return nil
        }
        guard showBuildNumber else {
            return "\(versionLabel) \(marketing)"
        }
        let build = buildNumberOverride ?? buildNumber
        guard let build, !build.isEmpty else {
            return "\(versionLabel) \(marketing)"
        }
        return "\(versionLabel) \(marketing) (\(build))"
    }
}
