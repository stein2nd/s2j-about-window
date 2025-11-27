# SPEC.md (DCOAboutWindow - SwiftUI Port)

## はじめに

* 本ドキュメントでは、Swift Package「S2J About Window」の専用仕様を定義します。
* 本ツールの設計は、以下の共通 SPEC に準拠します。
    * [Swift/SwiftUI 共通仕様](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md)
* 以下は、本ツール固有の仕様をまとめたものです。
* CI/CD に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

## 1. プロジェクト概要

* 名称: S2J About Window
* Swift Package 名: s2j-about-window
* 元リポジトリ: [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow)
* 目的: AppKit ベースの「About Window」を SwiftUI で再実装します
* 対応 OS: macOS v12以上、iPadOS v15以上

---

## 2. 要件ゴール

**要件レベルの凡例**:
* **Must (必須)**:
  * 本プロジェクトの成功に不可欠な要件であり、実装が必須です。
* **Should (推奨)**:
  * 本プロジェクトの品質向上に重要な要件であり、可能な限り実装を推奨します。
* **Could (可能であれば)**:
  * 本プロジェクトの価値を高める要件であり、実装可能であれば追加を検討します。

### 2.1. 機能要件

本プロジェクトは、macOS および iPadOS アプリケーション向けの About ウィンドウを提供する SwiftUI ベースのライブラリとして、以下の機能要件を満たす必要があります。

#### 2.1.1. About ウィンドウ表示機能

* **要件レベル**: **Must (必須)**
* **説明**: ホスト・アプリケーションから呼び出され、About ウィンドウを表示する機能を提供します。
* **詳細**:
  * macOS では、独立ウィンドウ (NSWindow) として表示します。
  * iPadOS では、Sheet または Popover モーダルとして表示します。
  * ウィンドウを閉じると自動でインスタンスを破棄します。

#### 2.1.2. アプリケーション情報の表示機能

* **要件レベル**: **Must (必須)**
* **説明**: アプリケーションの基本情報 (アプリケーション名、バージョン、著作権) を表示します。
* **詳細**:
  * アプリケーション名を表示します。
  * バージョン情報を表示します。
  * 著作権情報を表示します。
  * アプリケーション・アイコンを自動取得して表示します (macOS のみ)。

#### 2.1.3. コンテンツ表示機能

* **要件レベル**: **Must (必須)**
* **説明**: ホスト・アプリケーションから渡されたコンテンツ (ライセンス情報、その他の説明文など) を表示します。
* **詳細**:
  * Markdown 記法で記述されたテキスト情報を表示します (**Must** - 実装済み)。
  * JSON オブジェクト形式のコンテンツを表示します (**Should** - 未実装、Backlog に追加します)。
  * RTF ドキュメント形式のコンテンツを表示します (**Should** - 未実装、Backlog に追加します)。
  * コンテンツはスクロール可能で、テキスト選択が可能です。

#### 2.1.4. ローカライゼーション対応機能

* **要件レベル**: **Must (必須)**
* **説明**: 複数言語 (英語、日本語) に対応したローカライゼーション機能を提供します。
* **詳細**:
  * 英語 (en) と日本語 (ja) のローカライゼーションが必須です。
  * `Bundle.module` 経由で `Localizable.strings` を読み込みます。
  * デフォルト Markdown コンテンツ (`AboutDefault.md`) を用意し、利用側で上書き可能にします。

#### 2.1.5. ダークモード対応機能

* **要件レベル**: **Must (必須)**
* **説明**: macOS および iPadOS のダークモードに自動的に適応する機能を提供します。
* **詳細**:
  * システムの外観設定に応じて、ライトモード・ダークモードを自動切り替えします。
  * 背景色、テキスト色が適切に表示されるようにします。

#### 2.1.6. プラットフォーム固有 API 利用機能

* **要件レベル**: **Must (必須)**
* **説明**: macOS と iPadOS それぞれのプラットフォーム固有 API を適切に利用します。
* **詳細**:
  * macOS では、`NSWindow` および `NSHostingController` を利用します。
  * iPadOS では、SwiftUI ネイティブの `.sheet` / `.popover` API のみで構成します。
  * 共有ロジックは `#if canImport(SwiftUI)` ベースで共通化します。

### 2.2. 非機能要件

本プロジェクトは、Swift Package として他アプリケーションに組み込まれることを前提として、以下の非機能要件を満たす必要があります。

#### 2.2.1. 性能・効率性

* **要件レベル**: **Must (必須)**
* **応答時間**:
  * About ウィンドウの表示は、呼び出しから1秒以内の完了を目指します。
  * Markdown コンテンツのレンダリングは、コンテンツサイズ10KB 以下で0.5秒以内の完了を目指します。
* **メモリ使用量**:
  * About ウィンドウ表示時のメモリ使用量は、追加で10MB 以下に抑えることを目指します。
  * ウィンドウを閉じた際に、メモリリークが発生しないことを目指します。

#### 2.2.2. 互換性

* **要件レベル**: **Must (必須)**
* **プラットフォーム対応**:
  * macOS v12.0以上で動作すること。
  * iPadOS v15.0以上で動作すること。
* **Swift バージョン**:
  * Swift v5.9以上でビルド可能であること。
* **Xcode バージョン**:
  * Xcode v14.0以上でビルド可能であること。

#### 2.2.3. 信頼性

* **要件レベル**: **Must (必須)**
* **エラーハンドリング**:
  * Markdown パース失敗時は、プレーンテキストとして表示するフォールバック処理を実装すること。
  * 不正なコンテンツ形式が渡された場合でも、アプリケーションがクラッシュしないこと。
* **堅牢性**:
  * nil 値が渡された場合でも、適切なデフォルト値を表示すること。
  * リソースファイル (`AboutDefault.md`、`Localizable.strings`) が存在しない場合でも、エラーを発生させずに動作すること。

#### 2.2.4. 保守性

* **要件レベル**: **Must (必須)**
* **コード品質**:
  * MVVM パターンに準拠した設計とします。
  * 主要なクラス・メソッドに JSDoc スタイルのコメントを記載すること。
  * プラットフォーム固有のコードは `#if os(macOS)` / `#if os(iOS)` で適切に分離すること。
* **テスト容易性**:
  * ユニットテストが容易に記述できる設計とします。
  * Xcode Preview に対応すること。

#### 2.2.5. セキュリティ

* **要件レベル**: **Should (推奨)**
* **コンテンツの安全性**:
  * Markdown コンテンツに含まれるスクリプトや危険なリンクを適切に処理すること。
  * ユーザーが入力したコンテンツを表示する際は、XSS などの脆弱性を考慮すること。

#### 2.2.6. ユーザビリティ

* **要件レベル**: **Must (必須)**
* **UI / UX**:
  * 直感的で操作しやすい UI を提供すること。
  * ウィンドウサイズは適切なデフォルト値 (400x500) を設定すること。
  * コンテンツが長い場合は、スクロール可能にすること。
* **アクセシビリティ**:
  * VoiceOver などのスクリーンリーダーに対応すること (**Should** - 推奨)。
  * キーボード操作でウィンドウを閉じられること (macOS)。

#### 2.2.7. 開発者体験

* **要件レベル**: **Should (推奨)**
* **API の使いやすさ**:
  * シンプルで直感的な API を提供すること。
  * デフォルト値が適切に設定され、最小限のパラメータで動作すること。
* **ドキュメント**:
  * README.md に使用方法を記載すること。
  * API リファレンスを整備すること (**Could** - 可能であれば)。

#### 2.2.8. テスト・品質保証

* **要件レベル**: **Must (必須)**
* **テスト・カバレッジ**:
  * 主要な機能 (AboutWindow、AboutView、AboutViewModel、MarkdownView) のユニットテストを実装すること。
  * テスト・カバレッジは、70% 以上を目標とします。
* **UI テスト**:
  * SnapshotTesting フレームワークを使用した UI テストを実装すること (**Should** - 推奨)。
  * macOS と iPadOS それぞれのプラットフォームで UI テストを実施すること。
* **CI/CD でのテスト実行**:
  * CI/CD パイプラインで自動的にテストを実行し、テスト・カバレッジを収集すること。
  * CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

#### 2.2.9. パッケージング

* **要件レベル**: **Must (必須)**
* **Swift Package Manager 対応**:
  * Swift Package Manager で配布可能な形式とします。
  * Universal Binary 形式でビルド可能とします。
  * リソースファイル (`AboutDefault.md`、`Localizable.strings`、`Assets.xcassets`) を適切にパッケージングすること。

## 3. 準拠仕様

### 3.1. 技術スタック

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.2. 開発ルール

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.3. 国際化・ローカライズ

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.4. コーディング規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.5. デザイン規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.6. テスト方針

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。
* CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

## 4. 個別要件

**実装状況**: ✅ **基本機能は実装済み** - コア機能は実装完了。一部機能は未実装。

* 元リポジトリ (DCOAboutWindow) の Objective-C / AppKit 実装は参考とし、直接利用しません。
* UI は SwiftUI の `WindowGroup` / `Sheet` を利用します。
* ダークモード対応は、必須です。
* 本プロジェクトは、「Swift Package Manager」によって、Universal Binary 形式の Swift Package ツールとして他アプリケーション (以後、ホスト・アプリケーションと呼称) に組み込まれます。
* ホスト・アプリケーションからは、下記のいずれかによって呼び出され、「About ウィンドウ」として表示します。
    * メニューバー ▶︎ 「このアプリケーションについて」のクリック (✅実装済み - ホストアプリケーション側で `AboutWindow().showAboutWindow()` を呼び出し)
    * キー・コンビネーション (command I) のプレス (✅実装済み - ホスト・アプリケーション側で実装)
    * 「アプリケーション情報を表示」ボタンのクリック (✅実装済み - ホスト・アプリケーション側で実装)
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

### 4.1. プラットフォーム固有 API 利用方針

**実装状況**: ✅ **完全実装済み** - プラットフォーム固有 API の実装完了

* macOS 向け About ウィンドウでは、`NSWindow` および `NSHostingController` を利用します。(✅100% 実装完了 - `AboutWindow.swift` で実装)
  * `NSWindowDelegate` プロトコルを実装し、ウィンドウのライフサイクルを適切に管理します
  * タイトルバーの閉じるボタン（×）と ESC キーの両方でウィンドウを閉じることができます
* iPadOS 向けでは、`UIViewControllerRepresentable` を利用せず、SwiftUI のネイティブ `.sheet` / `.popover` API のみで構成します。(✅100% 実装完了 - `Extensions.swift` で実装)
* 共有ロジック (ViewModel / Markdown パーサー) は、すべて `#if canImport(SwiftUI)` ベースで共通化します。(✅100% 実装完了)

### 4.2. プロジェクト構成

```
`s2j-about-window`/
├── LICENSE
├── README.md
├┬─ docs/  # ドキュメント類
│├─ `SPEC.md`  # 本ドキュメント
│└─ `SPEC_CICD.md`  # CI/CD Workflow ドキュメント
├┬─ tools/
│└── docs-linter  # Git サブモジュール『Docs Linter』
├┬─ .github/  # CI/CD
│└┬─ workflows/
│　├─ docs-linter.yml
│　└─ swift-test.yml (✅100% 実装完了)
├┬─ scripts/  # スクリプト
│└─ test-local.sh  # ローカル・テスト実行スクリプト (✅100% 実装完了 - 統合版、汎用的)
├── SampleApp.swift  # エントリー・ポイント
├── Package.swift  # Swift Package 定義 (プロジェクト・ファイル兼用) (✅100% 実装完了)
├── project.yml  # XcodeGen 設定ファイル (✅100% 実装完了)
├┬─ Sources/
│└┬─ S2JAboutWindow/  # メイン・ソースコード
│　├─ AboutWindow.swift  # macOS: NSWindow 管理 + public API (✅100% 実装完了)
│　├─ AboutView.swift  # SwiftUI view (共通) (✅100% 実装完了)
│　├─ AboutViewModel.swift  # ViewModel (app metadata、markdown) (✅100% 実装完了)
│　├─ MarkdownView.swift  # Markdown を AttributedString で描画 (✅100% 実装完了)
│　├─ Extensions.swift  # iPadOS 向け拡張 (✅100% 実装完了)
│　└┬─ Resources/  # リソースファイル
│　　├─ AboutDefault.md  # デフォルトコンテンツ (✅100% 実装完了)
│　　├┬─ Assets.xcassets/  # アセット (✅100% 実装完了)
│　　│└─ Contents.json
│　　├─ Base.lproj/Localizable.strings  # ローカライゼーション (✅100% 実装完了)
│　　├─ en.lproj/Localizable.strings  # ローカライゼーション (✅100% 実装完了)
│　　└─ ja.lproj/Localizable.strings  # ローカライゼーション (✅100% 実装完了)
├┬─ Tests/
│└┬─ S2JAboutWindowTests/  # テストコード
│　└─ AboutViewTests.swift (⚠️ 実装中)
├── UITests/ (⚠️ 未実装)
└── Preview Content/ (⚠️ 未実装)
```

### 4.3. 主要ファイルの実装状況

* `Package.swift` : Swift Package 定義、リソース設定 (✅100% 実装完了)
* `project.yml` : XcodeGen 設定ファイル、macOS/iOS ターゲット定義、プラットフォーム専用スキーム定義 (✅100% 実装完了)
  * **ターゲット構成**:
    * `S2JAboutWindow-macOS`: macOS 向けフレームワーク
    * `S2JAboutWindow-iOS`: iOS 向けフレームワーク
    * `S2JAboutWindowTests-macOS`: macOS 向けテストバンドル
    * `S2JAboutWindowTests-iOS`: iOS 向けテストバンドル (署名設定: `CODE_SIGN_STYLE: Automatic`、`DEVELOPMENT_TEAM: ""`)
  * **スキーム構成**:
    * `S2JAboutWindow`: 統合スキーム (macOS + iOS)
    * `S2JAboutWindow-macOS`: macOS 専用スキーム (macOS ターゲットのみ)
    * `S2JAboutWindow-iOS`: iOS 専用スキーム (iOS ターゲットのみ)
* `AboutWindow.swift` : macOS 向け NSWindow 管理、showAboutWindow/closeWindow API、NSWindowDelegate 実装 (✅100% 実装完了)
* `AboutView.swift` : SwiftUI ビュー、アプリケーション・アイコン表示、アプリケーション情報表示、MarkdownView 統合 (✅100% 実装完了)
* `AboutViewModel.swift` : ViewModel、コンテンツ管理、アプリケーション・メタデータ管理、Bundle 拡張 (✅100% 実装完了)
* `MarkdownView.swift` : Markdown を AttributedString で描画、スクロール対応 (✅100% 実装完了)
* `Extensions.swift` : iPadOS 向け aboutSheet/aboutPopover 拡張 (✅100% 実装完了)
* `Resources/AboutDefault.md` : デフォルト Markdown コンテンツ (✅100% 実装完了)
* `Resources/Localizable.strings` : 英語・日本語ローカライゼーション (✅100% 実装完了)

### 4.4. アクセシビリティとローカライズ

**実装状況**: ✅ **完全実装済み** - 英語・日本語のローカライゼーション対応完了

* ローカライズ対応は、必須 (英語・日本語) の為、Base、English、Japanese を初期追加します。(✅100% 実装完了)
* `Bundle.module` 経由で `Localizable.strings` を読み込みます (SwiftPM の `resources: [.process("Resources")]`)。(✅100% 実装完了)
* Markdown のデフォルト文書 (`AboutDefault.md`) を用意し、利用側で上書き可能にします。(✅100% 実装完了)
* 文字列キー例: `"About.Title"`、`"About.NoDescription"`、`"About.Copyright"`、`"About.Close"`、`"About.Version"` (✅100% 実装完了)

## 5. デザイン規約

**実装状況**: ⚠️ **ほぼ実装済み** - ダークモード対応、アプリケーション・アイコン自動取得が完了 (macOS は完全実装、iPadOS は要確認)

* アイコンは App アイコンから自動取得します。(✅100% 実装完了 - `NSApplication.shared.applicationIconImage` を使用、macOS 専用)
* ダークモード対応は、必須です。(✅100% 実装完了 - macOS: `Color(NSColor.windowBackgroundColor)`、iPadOS: `Color(UIColor.systemBackground)` を使用)

## 6. 使用方法

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

## 8. テスト戦略

**実装状況**: ⚠️ **実装中** - テストコードの実装が進行中

* テスト: ライセンス表示部分は SnapshotTesting を実施します。(⚠️ 実装中)

**UI テスト環境**:
* macOS: `NSWindow` を表示し、タイトルおよび Markdown 表示内容を SnapshotTesting。(⚠️ 実装中)
* iPadOS: `.sheet` 表示を `XCTest` + `ViewInspector` で検証可能とします。(⚠️ 実装中)

**CI/CD でのテスト実行**:
* CI/CD パイプラインで自動的にテストを実行し、テスト・カバレッジを収集します。
* CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

## 9. CI / CD

CI/CD に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) を参照してください。

本セクションでは、CI/CD の概要のみを記載します。

* Swift Package のビルド成果物 (バイナリ / XCFramework) は Git 管理対象外とします。
* Universal Binary 化は SwiftPM のビルドフェーズで自動処理されます。
* リリース用ビルドは GitHub Actions の CI ワークフローで生成し、Artifacts として管理します。
* 本プロジェクトでは、以下の GitHub Actions ワークフローを導入します。
  * `docs-linter.yml`: Markdown ドキュメントの表記揺れ検出 (Docs Linter)
  * `swift-test.yml`: Swift Package のユニットテストおよび UI スナップショット・テストの自動実行 (✅100% 実装完了・テスト成功)

**実装状況**: ✅ **完全実装済み・テスト成功** - CI/CD ワークフローとローカルテスト・スクリプトの実装完了、GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功

## 10. 実装状況サマリー

本章では、「現在の実装状況」を記載します。

### 10.1. 完全実装済み機能 (100% 完了)

以下の機能は完全に実装され、テストも完了しています。

* コア機能
  * **AboutWindow.swift**:
    * macOS 向け NSWindow 管理、`showAboutWindow()` / `closeWindow()` API の実装。
    * `NSHostingController` を使用して SwiftUI ビューを NSWindow に統合します。
    * ウィンドウサイズ: 400x500、スタイル: `.titled`、`.closable`、`.miniaturizable` を設定します。
    * ウィンドウタイトルは `NSLocalizedString("About.Title", bundle: .module)` を使用します。
    * `NSObject` を継承し、`NSWindowDelegate` プロトコルを実装してウィンドウのライフサイクルを管理します。
    * `window.isReleasedWhenClosed = false` を設定し、`window.delegate = self` でデリゲートを設定します。
    * `windowWillClose(_:)` メソッドを実装し、ウィンドウが閉じられた際に適切にクリーンアップします。
    * タイトルバーの閉じるボタン（×）と ESC キーの両方でウィンドウを閉じることができます。
  * **AboutView.swift**:
    * SwiftUI ビュー、アプリケーション・アイコン表示、アプリケーション情報表示、MarkdownView 統合。
    * `@StateObject` を使用して `AboutViewModel` を管理します。
    * アプリケーション・アイコン: 64x64、角丸矩形 (`RoundedRectangle(cornerRadius: 12)`)。
    * アプリケーション情報: アプリケーション名 (`.title2`、`.bold`)、バージョン (`.subheadline`)、著作権 (`.caption`)。
    * プラットフォーム固有の背景色対応: macOS では `Color(NSColor.windowBackgroundColor)`、iPadOS では `Color(UIColor.systemBackground)` を使用。
    * プラットフォーム固有のアプリケーション・アイコン取得: macOS では `NSApplication.shared.applicationIconImage`、iPadOS では `UIImage(named:)` を使用。
    * Xcode Preview 対応 (`AboutView_Previews` を実装)。
  * **AboutViewModel.swift**:
    * ViewModel、コンテンツ管理、アプリケーション・メタデータ管理、Bundle 拡張機能。
    * `@Published` プロパティで `content`、`appName`、`version`、`copyright` を管理します。
    * `loadDefaultContent()` メソッドでデフォルトコンテンツを読み込みます。
    * Bundle 拡張: `displayName`、`version`、`copyright` プロパティを追加します。
  * **MarkdownView.swift**:
    * Markdown を `AttributedString` で描画し、スクロール対応、テキスト選択対応を実装します。
    * `AttributedString(markdown:)` を使用した Markdown レンダリング。
    * Markdown パース失敗時のフォールバック処理 (プレーンテキスト表示)。
    * `onAppear` と `onChange(of: content)` でコンテンツ変更に対応します。
    * Xcode Preview 対応 (`MarkdownView_Previews` を実装)
  * **Extensions.swift**:
    * iPadOS 向け `aboutSheet()` / `aboutPopover()` 拡張機能。
    * `aboutSheet()`: `NavigationView` を使用し、閉じるボタンをツールバーに配置。
    * `aboutPopover()`: 400x500px の固定サイズで表示します。
* プラットフォーム対応
  * **macOS 対応**:
    * `NSWindow` および `NSHostingController` を利用した独立ウィンドウ表示を実装します。
    * `#if os(macOS)` 条件分岐で macOS 専用コードを分離します。
    * `NSApplication.shared.applicationIconImage` でアプリケーション・アイコンを取得。
  * **iPadOS 対応**:
    * SwiftUI ネイティブ `.sheet` / `.popover` API によるモーダル表示を実装します。
    * `#if os(iOS)` 条件分岐で iOS/iPadOS 専用コードを分離します。
    * `NavigationView` と `ToolbarItem` を使用した UI 構成を実装します。
  * **マルチ・プラットフォーム対応**:
    * `#if canImport(SwiftUI)` ベースの共通化ロジック。
    * `@available(macOS 12.0, iOS 15.0, *)` でプラットフォーム要件を指定。
* リソース・ローカライゼーション
  * **Package.swift**:
    * Swift Package 定義、リソース設定 (`resources: [.process("Resources")]`)。
    * macOS/iPadOS 両対応のマルチプラットフォーム対応 (`.macOS(.v12)`、`.iOS(.v15)`)。
    * Swift Package として切り出し可能な構造。
    * デフォルトローカライゼーション: `defaultLocalization: "en"`。
  * **AboutDefault.md**:
    * デフォルト Markdown コンテンツ (使用例、機能説明、ライセンス情報を含む)。
  * **Localizable.strings**:
    * 英語・日本語ローカライゼーション (Base、en、ja)。
    * 文字列キー: `"About.Title"`、`"About.Close"`、`"About.NoDescription"`、`"About.Copyright"`、`"About.Version"`。
    * `Bundle.module` 経由で `NSLocalizedString` を使用してロード。
* UI/UX 機能
  * **ダークモード対応**:
    * macOS: `Color(NSColor.windowBackgroundColor)` を使用した自動対応 (✅実装完了)。
    * iPadOS: `Color(UIColor.systemBackground)` を使用した自動対応 (✅実装完了)。
  * **アプリケーション・アイコン自動取得**:
    * macOS: `NSApplication.shared.applicationIconImage` を使用 (✅実装完了)。
    * iPadOS: `UIImage(named: "AppIcon")` を使用 (✅実装完了)。
  * **アプリケーション・メタデータ自動取得**:
    * Bundle 拡張による `displayName`、`version`、`copyright` の自動取得。
* コンテンツ形式サポート
  * **Markdown 形式のコンテンツサポート**:
    * `MarkdownView.swift` で実装完了。
    * `AttributedString(markdown:)` を使用した Markdown レンダリング。
    * スクロール対応 (`ScrollView` を使用)、テキスト選択対応 (`.textSelection(.enabled)` を使用)。
    * Markdown パース失敗時のフォールバック処理 (プレーンテキストとして表示)。
    * `onAppear` と `onChange(of: content)` でコンテンツ変更に対応します。

### 10.2. ほとんど実装済み機能 (85-95% 完了)

以下の機能は実装がほぼ完了していますが、一部の機能やテストが未完了です。

* テストコード
  * **AboutViewTests.swift**: 基本的なユニットテストは実装済み。
    * ✅ `AboutViewModel` の初期化テスト (デフォルト値、nil 値の両方をテスト)。
    * ✅ `MarkdownView` の作成テスト。
    * ✅ `AboutView` の作成テスト。
    * ✅ `AboutWindow` の作成・表示・閉じるテスト (macOS)。
    * ⚠️ **SnapshotTesting フレームワークの統合が未実装** (テストメソッド `testAboutViewSnapshot()` と `testMarkdownViewSnapshot()` は存在するが、実際のスナップショット検証ロジックは未実装、コメントで「Note: This test would require SnapshotTesting framework」と記載されています)。

### 10.3. 未実装機能

以下の機能は仕様に記載されていますが、まだ実装されていません。

* コンテンツ形式サポート
  * **JSON オブジェクト形式のコンテンツサポート**:
    * Markdown のみ対応、JSON 形式のパース・表示機能は未実装。
  * **RTF ドキュメント形式のコンテンツサポート**:
    * RTF 形式のパース・表示機能は未実装。
* テスト・品質保証
  * **UI テスト・スナップショットテスト**:
    * SnapshotTesting フレームワークの統合と実際のスナップショット検証が未実装。
      * macOS:
        * `NSWindow` を表示し、タイトルおよび Markdown 表示内容を SnapshotTesting します。
      * iPadOS:
        * `.sheet` 表示を `XCTest` + `ViewInspector` で検証します。
  * **Preview Content**:
    * Xcode Preview 用のリソースディレクトリが未作成です。

### 10.4. 実装完了率

**実装完了率の算出方法**:
* 各機能カテゴリーの実装状況を評価し、重み付け平均で全体の完了率を算出。
* 完全実装済み (100%)、ほとんど実装済み (90%)、未実装 (0%) として計算。

**カテゴリー別完了率**:

| カテゴリー | 完了率 | 備考 |
|---|---|---|
| コア機能 | 100% | AboutWindow、AboutView、AboutViewModel、MarkdownView、Extensions すべて実装完了、Xcode Preview 対応も実装済み |
| プラットフォーム対応 | 100% | macOS と iPadOS の両方で完全実装 (プラットフォーム固有 API を適切に使用) |
| リソース・ローカライゼーション | 100% | 英語・日本語ローカライゼーション、デフォルトコンテンツ実装完了、`Bundle.module` 経由で適切に読み込み |
| UI/UX 機能 | 100% | macOS と iPadOS の両方でダークモード・アプリケーション・アイコン自動取得を実装完了 |
| CI/CD | 100% | GitHub Actions ワークフローとローカル・テストスクリプトの実装完了 (詳細は [SPEC_CICD.md](./SPEC_CICD.md) を参照) |
| コンテンツ形式サポート | 33% | Markdown のみ対応 (JSON、RTF は未実装、コメントやドキュメントには記載されているが実装されていない) |
| テスト・品質保証 | 60% | 基本的なユニットテストは実装済み (AboutViewModel、MarkdownView、AboutView、AboutWindow の作成・表示・閉じるテスト)、SnapshotTesting は未実装 (テストメソッドは存在するが実際の検証ロジックは未実装) |

**全体実装の完了率**: **約85%** (コア機能とプラットフォーム対応は完全実装、一部の拡張機能とテストが未実装)
* コア機能 (About Window の基本機能) は、100% 実装完了
  * macOS での動作は完全に実装済み。
  * iPadOS での動作も完全に実装済み (プラットフォーム固有 API を適切に使用)。
* プラットフォーム対応は、100% 実装完了 (macOS と iPadOS の両方で完全実装)。
* CI/CD は、100% 実装完了・テスト成功 (GitHub Actions ワークフローとローカル・テストスクリプトの実装完了、GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功)。
* 主要な拡張機能 (JSON/RTF サポート) は未実装です。Markdown サポートにより基本的な用途には対応可能です。
* テストコードについて: 基本的なユニットテストは実装済み。SnapshotTesting による UI テストは未実装。

### 10.5. 品質評価

* コード品質
  * ✅ **アーキテクチャー**:
    * MVVM パターンに準拠した設計、責務分離が適切。
    * `@StateObject`、`@Published` を適切に使用した状態管理。
  * ✅ **プラットフォーム対応**:
    * macOS/iPadOS 両対応、プラットフォーム固有 API を適切に利用します。
    * `AboutView.swift` でプラットフォーム固有の背景色とアプリケーション・アイコン取得を実装:
      * macOS: `Color(NSColor.windowBackgroundColor)` と `NSApplication.shared.applicationIconImage` を使用。
      * iPadOS: `Color(UIColor.systemBackground)` と `UIImage(named: "AppIcon")` を使用。
  * ✅ **エラーハンドリング**:
    * Markdown パース失敗時のフォールバック処理を実装します (`do-catch` でエラーを捕捉し、プレーンテキストとして表示します)。
  * ✅ **ドキュメント**:
    * 主要なクラス・メソッドに JSDoc スタイルのコメントを実装します。
    * パラメータ、戻り値、説明が適切に記載されています。
* テスト品質
  * ✅ **ユニットテスト**:
    * 基本的な機能のユニットテストを実装します (`AboutViewTests.swift`)。
  * ⚠️ **UI テスト**:
    * SnapshotTesting フレームワークの統合が未実装です。
  * ⚠️ **テスト・カバレッジ**:
    * 現時点では基本的なテストのみで、カバレッジは限定的です。
* 国際化・ローカライゼーション
  * ✅ **多言語対応**:
    * 英語・日本語のローカライゼーションを実装します。
  * ✅ **リソース管理**:
    * `Bundle.module` 経由で適切にリソースを読み込みます。
* パフォーマンス
  * ✅ **メモリ管理**:
    * SwiftUI の `@StateObject`、`@Published` を適切に使用。
    * `NSWindowDelegate` を実装し、`windowWillClose(_:)` メソッドでウィンドウが閉じられた際に適切にクリーンアップします。
    * `window.isReleasedWhenClosed = false` を設定し、ウィンドウのライフサイクルを適切に管理します。
  * ✅ **レンダリング**:
    * `AttributedString(markdown:)` による効率的な Markdown レンダリング。
* 総合評価
  * **総合品質**:
    * **良好** - コア機能は高品質に実装されており、基本的な用途には十分に対応可能。
  * **改善点**:
    * SnapshotTesting による UI テストの実装、JSON/RTF 形式のコンテンツサポート追加により、さらなる品質向上が期待できます。

## 11. Backlog

本章では、「今後の予定」を記載します。

### 11.1. 短期での改善予定 (1-3ヵ月)

品質保証と開発体験の向上を目的とした改善を、優先的に実施します。

* **UI テスト、スナップショット・テストの実装**
  * SnapshotTesting フレームワークの統合と実際のスナップショット検証を実装します。
  * macOS:
    * `NSWindow` を表示し、タイトルおよび Markdown 表示内容を SnapshotTesting します。
  * iPadOS:
    * `.sheet` 表示を `XCTest` + `ViewInspector` で検証します。
  * テスト・カバレッジを向上させます。
* **Preview Content の実装**
  * Xcode Preview 用のリソースディレクトリを作成します。
  * 開発時のプレビュー機能向上を図ります。

### 11.2. 中期での改善予定 (3-6ヵ月)

機能拡張を目的とした改善を実施します。

* **JSON オブジェクト形式のコンテンツサポート**
  * JSON 形式のパース・表示機能を実装します。
  * `AboutViewModel` での JSON コンテンツ処理を追加します。
  * Markdown と同様に `AboutView` で表示可能にします。
* **RTF ドキュメント形式のコンテンツサポート**
  * RTF 形式のパース・表示機能を実装します。
  * `NSAttributedString` を利用した RTF レンダリングを実装します。
  * Markdown、JSON と同様に `AboutView` で表示可能にします。

### 11.3. 長期での改善予定 (6ヵ月以上)

高度な機能や UX 向上を目的とした改善を検討します。

* **カスタマイズ可能なテーマ・スタイル設定**
  * カラーテーマのカスタマイズ機能。
  * フォントサイズ・スタイルのカスタマイズ機能。
  * レイアウトオプションを追加します。
* **アニメーション効果の追加**
  * ウィンドウ表示時のアニメーション。
  * コンテンツ読み込み時のアニメーション。
  * トランジション効果を追加します。
* **UI ローカライズについて、外部翻訳サービスとの連携**
  * 外部翻訳サービス (例: DeepL API) との連携を検討します。
  * 自動翻訳の機能を実装します。
  * 多言語対応を拡充します。

---

## Appendix A: Xcode プロジェクト作成ウィザード推奨選択肢リスト

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

**補足**:
* 本プロジェクトは Swift Package として他アプリケーションに組み込まれることを前提とするため、Xcode ウィザードで「App」テンプレートを選ぶ必要はありません。
* macOS/iPadOS 両対応の Swift Package として作成する場合は、「Framework」または「Swift Package」テンプレートを使用し、対応プラットフォームを .macOS (.v12)、.iOS (.v15) と指定します。
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
| iPadOS | iPadOS v16以降 (iPad Pro シミュレーター) | `.sheet` / `.popover` の UI 挙動確認 |

### 5. CI ワークフロー補足

**実装状況**: ✅ **完全実装済み・テスト成功** - CI ワークフローの実装完了、GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功

CI/CD に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) を参照してください。
