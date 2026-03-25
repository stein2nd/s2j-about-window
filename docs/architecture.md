<!-- 
目的：「フォルダー構成、主要ファイル、技術スタック、ビルド、責務」の明文化
 -->

# アーキテクチャー

## 設計方針

* **アーキテクチャー**:
    * MVVM パターンに準拠する。
* **共有ロジック**:
    * `#if canImport(SwiftUI)` および `#if os(macOS)` / `#if os(iOS)` でプラットフォームを分離し、ViewModel と Markdown レンダリングは共通化する。
* **プラットフォーム固有**:
    * macOS は `NSWindow` / `NSHostingController`、iPadOS は SwiftUI の `.sheet` / `.popover` のみで構成する。

## ディレクトリ・ファイルと責務

```
Sources/S2JAboutWindow/
├── AboutWindow.swift   # macOS: NSWindow 管理、showAboutWindow/closeWindow の public API、NSWindowDelegate
├── AboutView.swift     # SwiftUI ビュー（共通）: アイコン・アプリ情報・MarkdownView のレイアウト
├── AboutViewModel.swift # ViewModel: コンテンツ・appName/version/copyright、Bundle 拡張
├── MarkdownView.swift  # Markdown → AttributedString 描画、スクロール・テキスト選択、パース失敗時のフォールバック
├── Extensions.swift    # iPadOS: aboutSheet / aboutPopover の View 拡張
└── Resources/          # リソース（AboutDefault.md、Localizable.strings、Assets.xcassets）
```

| ファイル | 責務 |
|----------|------|
| **AboutWindow.swift** | macOS 専用。`NSWindow` の生成・表示・閉じる、`NSHostingController` で `AboutView` をホスト、`NSWindowDelegate` でライフサイクル管理。 |
| **AboutView.swift** | 共通。`AboutViewModel` を `@StateObject` で保持。アイコン・アプリ名・バージョン・著作権・`MarkdownView` を配置。プラットフォーム別の背景色・アイコン取得は `#if os` で分岐。 |
| **AboutViewModel.swift** | 共通。`content` / `appName` / `version` / `copyright` の保持、`Bundle` エクステンション（`displayName` / `version` / `copyright`）、`loadDefaultContent()`。 |
| **MarkdownView.swift** | 共通。`AttributedString(markdown:)` で Markdown を描画。失敗時はプレーンテキスト表示。`ScrollView` + テキスト選択対応。 |
| **Extensions.swift** | iPadOS 専用。`View` エクステンションで `aboutSheet` / `aboutPopover` を提供。内部で `AboutView` を表示。 |

## プラットフォーム分岐のルール

* **macOS のみ**:
    * `AboutWindow` クラス、`NSWindow` / `NSHostingController` / `NSApplication.shared.applicationIconImage`、`Color(NSColor.windowBackgroundColor)`。
* **iPadOS のみ**:
    * `aboutSheet` / `aboutPopover`、`NavigationView` + 閉じるボタン、`UIImage(named: "AppIcon")`、`Color(UIColor.systemBackground)`。
* **共通**:
    * `AboutView`、`AboutViewModel`、`MarkdownView`、`Bundle.resourceBundle`、リソース読み込み。

## テスト・プレビュー

* ユニットテスト:
    * `Tests/S2JAboutWindowTests/AboutViewTests.swift`（AboutViewModel、MarkdownView、AboutView、AboutWindow の作成・表示・閉じる）。
* Xcode Preview:
    * `AboutView_Previews`、`MarkdownView_Previews` を `#if DEBUG` で提供。

## 関連ドキュメント

* 仕様の入口:
    * [specs.md](./specs.md)
* プロジェクト概要:
    * [overview.md](./overview.md)
* 要件・実装状況:
    * [SPEC.md](./SPEC.md)
