# S2J About Window - アーキテクチャー

## 設計方針 `{@architecture:s-h001}`

* **最小 OS**: macOS v15.0、iOS v18.0 (`Package.swift` / `project.yml`、公開 API の `@available` と一致)。
* **Markdown 依存**: [Textual](https://github.com/gonzalezreal/textual) の `StructuredText` (`MarkdownView`)。
* **アーキテクチャー**:
    * MVVM パターンに準拠する。
* **共有ロジック**:
    * `#if canImport(SwiftUI)` および `#if os(macOS)` / `#if os(iOS)` でプラットフォームを分離し、ViewModel と Markdown レンダリングは共通化する。
* **プラットフォーム固有**:
    * macOS は `NSWindow` / `NSHostingController`、iPadOS は SwiftUI の `.sheet` / `.popover` のみで構成する。

## ディレクトリ・ファイルと責務 `{@architecture:s-h002}`

```
Sources/S2JAboutWindow/
├── AboutWindow.swift   # macOS: NSWindow 管理、showAboutWindow/closeWindow の public API、NSWindowDelegate
├── AboutView.swift     # SwiftUI ビュー (共通): アイコン・アプリケーション情報・MarkdownView のレイアウト
├── AboutViewModel.swift # ViewModel: コンテンツ・appName/version/copyright、Bundle 拡張
├── MarkdownView.swift  # Textual `StructuredText` による Markdown 描画 (About / Acknowledgements)
├── LegalTextView.swift # バンドル License 等のプレーン長文表示・シート — [legal_text_spec.md](./legal_text_spec.md)
├── LegalTextLoader.swift # ホスト Bundle からのリーガルテキスト読み込み
├── Extensions.swift    # iPadOS: aboutSheet (.sheet 直接) / aboutPopover、aboutSheetNavigationChrome
├── PreviewContent.swift # `#if DEBUG` — リポジトリ `Preview Content/` の Markdown を Canvas 用に読み込み
└── Resources/          # リソース (AboutDefault.md、Localizable.strings、Assets.xcassets)

Preview Content/        # リポジトリ直下 (SPM 配布外)。`AboutPreview.md` / `MarkdownPreview.md`。XcodeGen `DEVELOPMENT_ASSET_PATHS`
```

| ファイル | 責務 |
| --- | --- |
| **AboutWindow.swift** | macOS 専用。`NSWindow` の生成・表示・閉じる、`NSHostingController` で `AboutView` をホスト、`NSWindowDelegate` でライフサイクル管理。 |
| **AboutView.swift** | 共通。`AboutViewModel` を `@StateObject` で保持。アイコン・アプリケーション名・バージョン・著作権・`MarkdownView` を配置。プラットフォーム別の背景色・アイコン取得は `#if os` で分岐。 |
| **AboutViewModel.swift** | 共通。`content` / `appName` / `version` / `copyright` の保持、`Bundle` エクステンション (`displayName` / `version` / `copyright`)、`loadDefaultContent()`。 |
| **MarkdownView.swift** | 共通。[Textual](https://github.com/gonzalezreal/textual) `StructuredText`。About は `.default`、バンドル Acknowledgements `.md` は `.legalDocument` コンテキストで `.gitHub` + `overflowMode(.wrap)`。`ScrollView` + `.textual.textSelection(.enabled)`。 |
| **Extensions.swift** | iPadOS 専用。`View` エクステンションで `aboutSheet` / `aboutPopover` を提供。`aboutSheet` はエクステンション内で `.sheet` を直接付与し、シート本体は private `aboutSheetNavigationChrome(isPresented:about:)` (`NavigationView` + `about` クロージャの `AboutView` + iOS 閉じるボタン。SwiftLint 引数上限に対応 v3.0.9)。`aboutPopover` は `.popover` + 400×500で `AboutView` を表示。 |
| **LegalTextView.swift** | 共通。プレーン長文の等幅スクロール表示。`LegalTextDocumentSheet` が About からのシートを担当し、Acknowledgements `.md` は `MarkdownView` に委譲。 |
| **LegalTextLoader.swift** | 共通。`LegalTextKind` / `LegalTextContent` とバンドルリソース探索。I/O アダプタ。 |
| **PreviewContent.swift** | `#if DEBUG` のみ。`AboutView_Previews` / `MarkdownView_Previews` から利用。Periphery は `.periphery.yml` で Preview を保持。 |

## プラットフォーム分岐のルール `{@architecture:s-h003}`

* **macOS のみ**:
    * `AboutWindow` クラス、`NSWindow` / `NSHostingController` / `NSApplication.shared.applicationIconImage`、`Color(NSColor.windowBackgroundColor)`。
* **iPadOS のみ**:
    * `aboutSheet` / `aboutPopover`。`aboutSheet` の `.sheet` は **カスタム `ViewModifier` に包まず** `View` エクステンションに直接付与する (ViewInspector / CI `test-ios` の `AboutSheetInspectorTests` がホストチェーン上の `.sheet` を要求するため。v3.0.7)。
    * `NavigationView` + 閉じるボタン、`UIImage(named: "AppIcon")`、`Color(UIColor.systemBackground)`。
* **共通**:
    * `AboutView`、`AboutViewModel`、`MarkdownView`、`LegalTextView` / `LegalTextLoader`、`Bundle.resourceBundle`、リソース読み込み。

## テスト・プレビュー `{@architecture:s-h004}`

* ユニットテスト:
    * `AboutViewTests.swift` (XCTest: AboutViewModel、MarkdownView、AboutView、AboutWindow)。旧 Snapshot プレースホルダは `AboutViewSnapshotTests` へ集約。
    * `LegalTextLoaderTests.swift` (Swift Testing: ローダー・拡張子探索・`usesMarkdownRendering`)。
    * テストリソース: `Resources/` (`FixtureLicense*.txt`、`FixtureAcknowledgements.md` など)。
* Snapshot / UI テスト:
    * `AboutViewSnapshotTests.swift` — [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)。macOS: `NSHostingView` + `.image(precision: 0.98)`。参照 PNG は `__Snapshots__/AboutViewSnapshotTests/` (2件)。CI `test-macos` (`CI=true`) で比較、記録は `update-snapshots` (macos-26)。
    * `AboutSheetInspectorTests.swift` — `#if os(iOS)`。ホスト `Color.clear.aboutSheet(...)` に対し `inspect().color().sheet()` → `find(AboutView.self)` (`test-ios` / XcodeGen `S2JAboutWindowTests-iOS`)。カスタム `ViewModifier` 内の `.sheet` は ViewInspector で検出されない。
    * テスト依存 (`swift-snapshot-testing` 1.18+、`ViewInspector` 0.10+): `Package.swift` の `S2JAboutWindowTests` と、`project.yml` のプラットフォーム別テストターゲット (macOS: Snapshot、iOS: ViewInspector。iOS ターゲットは `AboutViewSnapshotTests` / `__Snapshots__` をコンパイル対象から除外)。
* Xcode Preview:
    * `AboutView_Previews`、`MarkdownView_Previews` を `#if DEBUG` で提供。
    * リポジトリ直下 `Preview Content/` (`AboutPreview.md` / `MarkdownPreview.md`) を `PreviewContent.swift` が読み込み。XcodeGen は `DEVELOPMENT_ASSET_PATHS` を設定。

## 関連ドキュメント `{@architecture:s-h005}`

* 仕様の入口:
    * [specs.md](./specs.md)
* プロジェクト概要:
    * [overview.md](./overview.md)
* 要件・実装状況:
    * [SPEC.md](./SPEC.md)
* License / Acknowledgements:
    * [legal_text_spec.md](./legal_text_spec.md)
