# SPEC.md (DCOAboutWindow - SwiftUI Port)

## プロジェクト概要

* 名称: S2J About Window
* Swift Package 名: s2j-about-window
* 元リポジトリ: [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow)
* 目的: AppKit ベースの「About Window」を SwiftUI で再実装する
* 対応 OS: macOS v12以上、iPadOS v15以上

**実装状況**: ✅ **基本機能は実装済み** - コア機能は実装完了、一部機能は未実装

## 技術スタック

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## 開発ルール

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## 国際化・ローカライズ

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## コーディング規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## デザイン規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## テスト方針

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## 個別要件

* 元リポジトリ (DCOAboutWindow) の Objective-C / AppKit 実装は参考とし、直接利用しません。
* UI は SwiftUI の `WindowGroup` / `Sheet` を利用します。
* ダークモード対応は、必須です。
* 本プロジェクトは、「Swift Package Manager」によって、Universal Binary 形式の Swift Package ツールとして他アプリケーション (以後、ホスト・アプリケーションと呼称) に組み込まれます。
* ホスト・アプリケーションからは、下記のいずれかによって呼び出され、「About ウィンドウ」として表示します。
    * メニューバー ▶︎ 「このアプリケーションについて」のクリック (✅実装済み - ホストアプリ側で `AboutWindow().showAboutWindow()` を呼び出し)
    * キー・コンビネーション (command I) のプレス (✅実装済み - ホストアプリ側で実装)
    * 「アプリケーション情報を表示」ボタンのクリック (✅実装済み - ホストアプリ側で実装)
* 「About ウィンドウ」としての表示情報は、下記のとおりです。
    * アプリケーション名
    * バージョン
    * 著作権
    * ライセンス情報
    * その他、ホスト・アプリケーションが指定する内容
* ホスト・アプリケーションからは、下記のいずれかの手段で、「About ウィンドウ」への表示内容が渡されます。
    * Markdown 記法で記述されたテキスト情報 (✅100% 実装完了 - `AttributedString(markdown:)` を使用)
    * JSON オブジェクト (⚠️ 未実装 - Backlog に追加)
    * RTF ドキュメント (⚠️ 未実装 - Backlog に追加)
* ホスト・アプリケーションは、macOS アプリケーション (または iPadOS アプリケーション) を想定します。
    * macOS の場合は、「独立ウィンドウ / パネル (App の About)」として「About ウィンドウ」をポップアップし、ウィンドウを閉じると自動でインスタンスを破棄します。(✅100% 実装完了 - `AboutWindow` クラスで実装)
    * iPadOS の場合は、`.sheet` または `.popover` モーダルで同じ `AboutView(content:)` を表示できるようにします。(✅100% 実装完了 - `Extensions.swift` で `aboutSheet`/`aboutPopover` を実装)
        * 例: `AboutView(content: aboutContent)` を `sheet(isPresented:)` から呼び出す。(✅100% 実装完了)

### プラットフォーム固有 API 利用方針

**実装状況**: ✅ **完全実装済み** - プラットフォーム固有 API の実装完了

* macOS 向け About ウィンドウでは、`NSWindow` および `NSHostingController` を利用します。(✅100% 実装完了 - `AboutWindow.swift` で実装)
* iPadOS 向けでは、`UIViewControllerRepresentable` を利用せず、SwiftUI のネイティブ `.sheet` / `.popover` API のみで構成します。(✅100% 実装完了 - `Extensions.swift` で実装)
* 共有ロジック (ViewModel / Markdown パーサー) は、すべて `#if canImport(SwiftUI)` ベースで共通化します。(✅100% 実装完了)

### プロジェクト構成

```
`s2j-about-window`/
├┬─ docs/  # ドキュメント類
│└─ `SPEC.md`  # 本ドキュメント
├┬─ tools/
│└┬─ docs-linter  # Git サブモジュール『Docs Linter』
│　└┬─ dist/
│　　└─ `run-textlint.js`
├┬─ .github/  # CI/CD
│└┬─ workflows/
│　├─ docs-linter.yml
│　└─ swift-test.yml
├── LICENSE
├── README.md
├── SampleApp.swift  # エントリー・ポイント
├── Package.swift  # Swift Package 定義 (プロジェクト・ファイル兼用) (✅100% 実装完了)
├┬─ Sources/
│└┬─ S2JAboutWindow/  # メイン・ソースコード
│　├─ AboutWindow.swift  # macOS: NSWindow 管理 + public API (✅100% 実装完了)
│　├─ AboutView.swift  # SwiftUI view (共通) (✅100% 実装完了)
│　├─ AboutViewModel.swift  # ViewModel (app metadata、markdown) (✅100% 実装完了)
│　├─ MarkdownView.swift  # Markdown を AttributedString で描画 (✅100% 実装完了)
│　├─ Extensions.swift  # iPadOS 向け拡張 (✅100% 実装完了)
│　├┬─ Resources/  # リソースファイル
│　│├─ AboutDefault.md  # デフォルトコンテンツ (✅100% 実装完了)
│　│├─ Assets.xcassets/  # アセット (✅100% 実装完了)
│　│└┬─ Localizable.strings/  # ローカライゼーション (Base、en、ja、…) (✅100% 実装完了)
│　│ ├─ Base.lproj/Localizable.strings (✅100% 実装完了)
│　│ ├─ en.lproj/Localizable.strings (✅100% 実装完了)
│　│ └─ ja.lproj/Localizable.strings (✅100% 実装完了)
├┬─ Tests/
│└┬─ S2JAboutWindowTests/  # テストコード
│　└─ AboutViewTests.swift (⚠️ 実装中)
├── UITests/ (⚠️ 未実装)
└── Preview Content/ (⚠️ 未実装)
```

### 2.1. 主要ファイルの実装状況

* `Package.swift` : Swift Package 定義、リソース設定 (✅100% 実装完了)
* `AboutWindow.swift` : macOS 向け NSWindow 管理、showAboutWindow/closeWindow API (✅100% 実装完了)
* `AboutView.swift` : SwiftUI ビュー、アプリケーション・アイコン表示、アプリケーション情報表示、MarkdownView 統合 (✅100% 実装完了)
* `AboutViewModel.swift` : ViewModel、コンテンツ管理、アプリメタデータ管理、Bundle 拡張 (✅100% 実装完了)
* `MarkdownView.swift` : Markdown を AttributedString で描画、スクロール対応 (✅100% 実装完了)
* `Extensions.swift` : iPadOS 向け aboutSheet/aboutPopover 拡張 (✅100% 実装完了)
* `Resources/AboutDefault.md` : デフォルト Markdown コンテンツ (✅100% 実装完了)
* `Resources/Localizable.strings` : 英語・日本語ローカライゼーション (✅100% 実装完了)

### 国際化・ローカライズ

**実装状況**: ✅ **完全実装済み** - 英語・日本語のローカライゼーション対応完了

* ローカライズ対応は、必須 (英語・日本語) の為、Base、English、Japanese を初期追加します。(✅100% 実装完了)
* `Bundle.module` 経由で `Localizable.strings` を読み込んでください (SwiftPM の `resources: [.process("Resources")]`)。(✅100% 実装完了)
* Markdown のデフォルト文書 (`AboutDefault.md`) を用意し、利用側で上書きできるようにしてください。(✅100% 実装完了)
* 文字列キー例: `"About.Title"`、`"About.NoDescription"`、`"About.Copyright"`、`"About.Close"`、`"About.Version"` (✅100% 実装完了)

### デザイン規約

**実装状況**: ✅ **完全実装済み** - ダークモード対応、アプリケーション・アイコン自動取得が完了

* アイコンは App アイコンから自動取得します。(✅100% 実装完了 - `NSApplication.shared.applicationIconImage` を使用)
* ダークモード対応は、必須です。(✅100% 実装完了 - `Color(NSColor.windowBackgroundColor)` を使用)

### 使用方法

**実装状況**: ✅ **完全実装済み** - 使用方法の実装完了

**macOS:**

```swift
let aboutWindow = AboutWindow()
aboutWindow.showAboutWindow(
    content: "Your content",
    appName: "App",
    version: "1.0.0",
    copyright: "© 2024 Your Company"
)
```

**iPadOS:**

```swift
// Sheet として表示
.aboutSheet(
    isPresented: $showAbout,
    content: "Your content",
    appName: "App",
    version: "1.0.0",
    copyright: "© 2024 Your Company"
)

// Popover として表示
.aboutPopover(
    isPresented: $showAbout,
    content: "Your content",
    appName: "App",
    version: "1.0.0",
    copyright: "© 2024 Your Company"
)
```

### テスト方針

**実装状況**: ⚠️ **実装中** - テストコードの実装が進行中

* テスト: ライセンス表示部分は SnapshotTesting を実施します。(⚠️ 実装中)

**UI テスト環境**:
* macOS: `NSWindow` を表示し、タイトルおよび Markdown 表示内容を SnapshotTesting。(⚠️ 実装中)
* iPadOS: `.sheet` 表示を `XCTest` + `ViewInspector` で検証可能とする。(⚠️ 実装中)

### ビルド出力ポリシー

* Swift Package のビルド成果物 (バイナリ / XCFramework) は Git 管理対象外とします。
* Universal Binary 化は SwiftPM のビルドフェーズで自動処理されます。
* リリース用ビルドは GitHub Actions の CI ワークフローで生成し、Artifacts として管理します。

## Appendix A: Xcode プロジェクト作成ウィザード推奨選択肢リスト

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

**補足**:
* 本プロジェクトは Swift Package として他アプリケーションに組み込まれることを前提とするため、Xcode ウィザードで「App」テンプレートを選ぶ必要はありません。
* macOS/iPadOS 両対応の Swift Package として作成する場合は、「Framework」または「Swift Package」テンプレートを使用し、対応プラットフォームを .macOS (.v12)、.iOS (.v15) と指定してください。
* また、本リポジトリでは Git サブモジュール [Docs Linter](https://github.com/stein2nd/docs-linter) を導入し、ドキュメント品質 (表記揺れや用語統一) の検証を CI で実施します。

### 1. テンプレート選択

* **Platform**: Multiplatform (macOS、iPadOS)
* **Template**: Framework または Swift Package

### 2. プロジェクト設定

| 項目 | 推奨値 | 理由 |
|---|---|---|
| Product Name | `s2j-about-window` | `SPEC.md` のプロダクト名と一致 |
| Team | Apple ID に応じて設定 | コード署名のため |
| Organization Identifier | `com.s2j` | ドメイン逆引き規則、一貫性確保 |
| Interface | SwiftUI | SwiftUI ベースを前提 |
| Language | Swift (Swift v7.0) | Xcode v26.0.1に同梱される Swift バージョン (Objective-C は不要) |
| Use Core Data | Off | データ永続化不要 |
| Include Tests | On | `SPEC.md` にもとづきテストを考慮 |
| Include CloudKit | Off | 不要 |
| Include Document Group | Off | Document-based App ではない |
| Source Control | On (Git) | `SPEC.md` / GitHub 運用をリンクさせるため |

### 3. デプロイ設定

| 項目 | 推奨値 | 理由 |
|---|---|---|
| macOS Deployment Target | macOS v12.0以上 | AppKit との互換確保 (NSWindowBridge で使用) |
| iOS Deployment Target | iPadOS v15.0以上 | .sheet / .popover の SwiftUI API が安定するバージョン |

### 4. 実行確認の環境 (推奨)

| プラットフォーム | 実行確認ターゲット | 理由 |
|---|---|---|
| macOS | macOS v13 (Ventura) 以降 | NSWindow の動作確認 |
| iPadOS | iPadOS v16以降 (iPad Pro シミュレータ) | `.sheet` / `.popover` の UI 挙動確認 |

### 5. CI ワークフロー補足

* 本プロジェクトでは、以下の GitHub Actions ワークフローを導入します。
    * `docs-linter.yml`: Markdown ドキュメントの表記揺れ検出 (Docs Linter)
    * `swift-test.yml`: Swift Package のユニットテストおよび UI スナップショットテストの自動実行
* macOS Runner では `swift test --enable-code-coverage` を実行し、テストカバレッジを出力します。
* iPadOS 互換性テストは、`xcodebuild test -scheme S2JAboutWindow -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch)'` で検証します。

## Backlog

### 未実装機能

* JSON オブジェクト形式のコンテンツサポート (⚠️ 未実装)
* RTF ドキュメント形式のコンテンツサポート (⚠️ 未実装)
* UI テスト・スナップショットテストの実装 (⚠️ 実装中)

### 将来の拡張機能

* UI ローカライズについて、外部翻訳サービス (例: DeepL API) との連携を検討する。
* カスタマイズ可能なテーマ・スタイル設定
* アニメーション効果の追加

### 完了した機能

* ✅ ライセンスビューで Markdown をサポートする。(✅100% 実装完了 - `MarkdownView.swift` で実装)
* ✅ Swift Package として切り出し可能な構造にする。(✅100% 実装完了 - `Package.swift` で実装)
