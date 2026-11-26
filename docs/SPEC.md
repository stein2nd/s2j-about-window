# S2J About Window - DCOAboutWindow - SwiftUI Port

## はじめに `{@spec:s-h001}`

* 本ドキュメントでは、Swift Package「S2J About Window」の専用仕様を定義します。
* 本ツールの設計は、以下の共通 SPEC に準拠します。
    * [Swift/SwiftUI 共通仕様](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md)
* 以下は、本ツール固有の仕様をまとめたものです。
* CI/CD に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。
* **仕様の細分化**: プロジェクトの存在理由、コード構造、CI/CD などは別ドキュメントに分割しています。一覧は [specs.md](./specs.md) を参照してください。細分化の方針とベター・プラクティスは [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md) に記載しています。

## 1. プロジェクト概要 `{@spec:s1}`

* 名称: S2J About Window
* Swift Package 名: s2j-about-window
* 元リポジトリ: [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow)
* 目的: AppKit ベースの「About Window」を SwiftUI で再実装します
* 対応 OS: macOS v15以上、iPadOS v18以上 (**3.0.0** 以降。[Textual](https://github.com/gonzalezreal/textual) 利用により最小 OS を引き上げ)
* バンドル License / Acknowledgements: [legal_text_spec.md](./legal_text_spec.md) (Issue #17完了、2.0.13〜3.0.1)

---

## 2. 要件ゴール `{@spec:s2}`

**要件レベルの凡例**:
* **Must (必須)**:
  * 本プロジェクトの成功に不可欠な要件であり、実装が必須です。
* **Should (推奨)**:
  * 本プロジェクトの品質向上に重要な要件であり、可能な限り実装を推奨します。
* **Could (可能であれば)**:
  * 本プロジェクトの価値を高める要件であり、実装可能であれば追加を検討します。

### 2.1. 機能要件 `{@spec:s2-1}`

本プロジェクトは、macOS および iPadOS アプリケーション向けの About ウィンドウを提供する SwiftUI ベースのライブラリとして、以下の機能要件を満たす必要があります。

#### 2.1.1. About ウィンドウ表示機能 `{@spec:s2-1-1}`

* **要件レベル**: **Must (必須)**
* **説明**: ホスト・アプリケーションから呼び出され、About ウィンドウを表示する機能を提供します。
* **詳細**:
  * macOS では、独立ウィンドウ (NSWindow) として表示します。
  * iPadOS では、Sheet または Popover モーダルとして表示します。
  * ウィンドウを閉じると自動でインスタンスを破棄します。

#### 2.1.2. アプリケーション情報の表示機能 `{@spec:s2-1-2}`

* **要件レベル**: **Must (必須)**
* **説明**: アプリケーションの基本情報 (アプリケーション名、バージョン、著作権) を表示します。
* **詳細**:
  * アプリケーション名を表示します。
  * バージョン情報を表示します。
  * 著作権情報を表示します。
  * アプリケーション・アイコンを自動取得して表示します (macOS のみ)。

#### 2.1.3. コンテンツ表示機能 `{@spec:s2-1-3}`

* **要件レベル**: **Must (必須)**
* **説明**: ホスト・アプリケーションから渡されたコンテンツ (ライセンス情報、その他の説明文など) を表示します。
* **詳細**:
  * Markdown 記法で記述されたテキスト情報を表示します (**Must** - 実装済み)。
  * JSON オブジェクト形式のコンテンツを表示します (**Should** — 実装済み: `AboutContentView` / `AboutContentFormat`。整形表示、`.automatic` でパース失敗時は Markdown にフォールバック)。
  * RTF ドキュメント形式のコンテンツを表示します (**Should** — 実装済み: RTF 文字列を `AttributedString` で表示)。
  * 公開 `AboutContentType` と `contentType` 引数 (**Should** — デフォルト `.automatic`。`AboutContentType.effective(for:requested:)` / `AboutViewModel.effectiveContentType`)。
  * コンテンツはスクロール可能で、テキスト選択が可能です。

#### 2.1.4. ローカライゼーション対応機能 `{@spec:s2-1-4}`

* **要件レベル**: **Must (必須)**
* **説明**: 複数言語 (英語、日本語) に対応したローカライゼーション機能を提供します。
* **詳細**:
  * 英語 (en) と日本語 (ja) のローカライゼーションが必須です。
  * `Bundle.module` 経由で `Localizable.strings` を読み込みます。
  * デフォルト Markdown コンテンツ (`AboutDefault.md`) を用意し、利用側で上書き可能にします。

#### 2.1.5. ダークモード対応機能 `{@spec:s2-1-5}`

* **要件レベル**: **Must (必須)**
* **説明**: macOS および iPadOS のダークモードに自動的に適応する機能を提供します。
* **詳細**:
  * システムの外観設定に応じて、ライトモード・ダークモードを自動切り替えします。
  * 背景色、テキスト色が適切に表示されるようにします。

#### 2.1.6. プラットフォーム固有 API 利用機能 `{@spec:s2-1-6}`

* **要件レベル**: **Must (必須)**
* **説明**: macOS と iPadOS それぞれのプラットフォーム固有 API を適切に利用します。
* **詳細**:
  * macOS では、`NSWindow` および `NSHostingController` を利用します。
  * iPadOS では、SwiftUI ネイティブの `.sheet` / `.popover` API のみで構成します。
  * 共有ロジックは `#if canImport(SwiftUI)` ベースで共通化します。

### 2.2. 非機能要件 `{@spec:s2-2}`

本プロジェクトは、Swift Package として他アプリケーションに組み込まれることを前提として、以下の非機能要件を満たす必要があります。

#### 2.2.1. 性能・効率性 `{@spec:s2-2-1}`

* **要件レベル**: **Must (必須)**
* **応答時間**:
  * About ウィンドウの表示は、呼び出しから1秒以内の完了を目指します。
  * Markdown コンテンツのレンダリングは、コンテンツサイズ10KB 以下で0.5秒以内の完了を目指します。
* **メモリ使用量**:
  * About ウィンドウ表示時のメモリ使用量は、追加で10MB 以下に抑えることを目指します。
  * ウィンドウを閉じた際に、メモリリークが発生しないことを目指します。

#### 2.2.2. 互換性 `{@spec:s2-2-2}`

* **要件レベル**: **Must (必須)**
* **プラットフォーム対応**:
  * macOS: v15.0以上で動作すること。
  * iPadOS: v18.0以上で動作すること。
* **Swift バージョン**:
  * Swift: v6.3以上でビルド可能であること (`swift-tools-version: 6.3`)。
* **Xcode バージョン**:
  * Xcode: v26.x 以降を推奨 (CI は v26.5等を使用。Swift v6.3同梱)。

#### 2.2.3. 信頼性 `{@spec:s2-2-3}`

* **要件レベル**: **Must (必須)**
* **エラー・ハンドリング**:
  * About 本文の Markdown は Textual `StructuredText` で描画します (詳細は [architecture.md](./architecture.md))。
  * バンドルリーガルテキストのロード失敗・空ファイルは `LegalTextContent` で UI に明示します ([legal_text_spec.md](./legal_text_spec.md))。
  * 不正なコンテンツ形式が渡された場合:
    * アプリケーションがクラッシュしないようにします。
* **堅牢性**:
  * nil 値が渡された場合:
    * 適切なデフォルト値を表示します。
  * リソースファイル (`AboutDefault.md`、`Localizable.strings`) が存在しない場合:
    * エラーを発生させずに動作します。

#### 2.2.4. 保守性 `{@spec:s2-2-4}`

* **要件レベル**: **Must (必須)**
* **コード品質**:
  * 設計: MVVM パターンに準拠します。
  * 主要なクラス・メソッド: JSDoc スタイルのコメントを記載します。
  * プラットフォーム固有のコード: `#if os(macOS)` / `#if os(iOS)` で適切に分離します。
* **テスト容易性**:
  * 設計: ユニットテストが容易に記述できるようにします。
  * Xcode Preview に対応します (✅ `Preview Content/` + `PreviewContent.swift` で `AboutView` / `MarkdownView` の Canvas がリポジトリ内 Markdown を表示)。

#### 2.2.5. セキュリティ `{@spec:s2-2-5}`

* **要件レベル**: **Should (推奨)**
* **コンテンツの安全性**:
  * Markdown コンテンツに含まれるスクリプトや危険なリンク: 適切に処理します。
  * ユーザーが入力したコンテンツを表示する際: XSS などの脆弱性を、考慮します。

#### 2.2.6. ユーザビリティ `{@spec:s2-2-6}`

* **要件レベル**: **Must (必須)**
* **UI / UX**:
  * 直感的で操作しやすい UI を、提供します。
  * ウィンドウサイズ: 適切なデフォルト値 (400x500) を設定します。
  * コンテンツが長い場合: スクロール可能にします。
* **アクセシビリティ**:
  * VoiceOver などのスクリーンリーダーに対応します (**Should** - 推奨)。
  * キーボード操作で、ウィンドウを閉じることができるようにします (macOS)。

#### 2.2.7. 開発者体験 `{@spec:s2-2-7}`

* **要件レベル**: **Should (推奨)**
* **API の使いやすさ**:
  * シンプルで直感的な API を提供します。
  * デフォルト値が適切に設定され、最小限のパラメータで動作可能にします。
* **ドキュメント**:
  * README.md に使用方法を記載します。
  * API リファレンスを整備します (**Could** - 可能であれば)。

#### 2.2.8. テスト・品質保証 `{@spec:s2-2-8}`

* **要件レベル**: **Must (必須)**
* **テスト・カバレッジ**:
  * 主要な機能 (AboutWindow、AboutView、AboutViewModel、MarkdownView) のユニットテストを実装します。
  * テスト・カバレッジ目標: 70% 以上です。
* **UI テスト**:
  * SnapshotTesting を用いた About 画面の UI テスト (**Should** — 実装済み: `AboutViewSnapshotTests`)。`LegalTextView` / macOS `NSWindow` 全体は Backlog。
  * macOS: `NSHostingView` 経由の画像スナップショット。iPadOS: ViewInspector による `aboutSheet` 検証 (`AboutSheetInspectorTests`、`inspect().color().sheet()`。`aboutSheet` は View 直下の `.sheet` 実装。CI `test-ios`)。
* **CI/CD でのテスト実行**:
  * CI/CD パイプラインで自動的にテストを実行し、テスト・カバレッジを収集します。
  * CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

#### 2.2.9. パッケージング `{@spec:s2-2-9}`

* **要件レベル**: **Must (必須)**
* **Swift Package Manager 対応**:
  * Swift Package Manager で配布可能な形式にします。
  * Universal Binary 形式でビルド可能にします。
  * リソースファイル (`AboutDefault.md`、`Localizable.strings`、`Assets.xcassets`) を適切にパッケージングします。

## 3. 準拠仕様 `{@spec:s3}`

### 3.1. 技術スタック `{@spec:s3-1}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.2. 開発ルール `{@spec:s3-2}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.3. 国際化・ローカライズ `{@spec:s3-3}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.4. コーディング規約 `{@spec:s3-4}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.5. デザイン規約 `{@spec:s3-5}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.6. テスト方針 `{@spec:s3-6}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。
* CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

## 4. 個別要件 `{@spec:s4}`

**実装状況**: ✅ **基本機能は実装済み** - コア機能は、実装完了。一部機能は、未実装。

* 元リポジトリ (DCOAboutWindow) の Objective-C / AppKit 実装は参考とし、直接利用しません。
* UI は SwiftUI の `WindowGroup` / `Sheet` を利用します。
* ダークモード対応は、必須です。
* 本プロジェクトは、「Swift Package Manager」によって、Universal Binary 形式の Swift Package ツールとして他アプリケーション (以後、ホスト・アプリケーションと呼称) に組み込まれます。
* ホスト・アプリケーションからは、下記のいずれかによって呼び出され、「About ウィンドウ」として表示します。
    * 「メニューバー > このアプリケーションについて」のクリック (✅実装済み - ホストアプリケーション側で `AboutWindow().showAboutWindow()` を呼び出し)
    * キー・コンビネーション (command I) のプレス (✅実装済み - ホスト・アプリケーション側で実装)
    * 「アプリケーション情報を表示」ボタンのクリック (✅実装済み - ホスト・アプリケーション側で実装)
* 「About ウィンドウ」としての表示情報は、下記のとおりです。
    * アプリケーション名
    * バージョン
    * 著作権
    * ライセンス情報
    * その他、ホスト・アプリケーションが指定する内容
* ホスト・アプリケーションからは、下記のいずれかの手段で、「About ウィンドウ」への表示内容が渡されます。
    * Markdown 記法で記述されたテキスト情報 (✅100% 実装完了 - Textual `StructuredText` / `MarkdownView`)
    * バンドル同梱 License / Acknowledgements (✅100% 実装完了 - `LegalTextLoader` / シート表示。仕様: [legal_text_spec.md](./legal_text_spec.md))
    * JSON オブジェクト (✅ Should 実装完了 - `AboutContentFormat`)
    * RTF ドキュメント (✅ Should 実装完了 - `AboutContentFormat`)
* ホスト・アプリケーションは、macOS アプリケーション (または iPadOS アプリケーション) を想定します。
    * macOS の場合は、「独立ウィンドウ / パネル (App の About)」として「About ウィンドウ」をポップアップし、ウィンドウを閉じると自動でインスタンスを破棄します。(✅100% 実装完了 - `AboutWindow` クラスで実装)
    * iPadOS の場合は、`.sheet` または `.popover` モーダルで同じ `AboutView(content:)` を表示できるようにします。(✅100% 実装完了 - `Extensions.swift` で `aboutSheet`/`aboutPopover` を実装)
        * `aboutSheet` は `View` エクステンション内で SwiftUI `.sheet` を直接適用する (`aboutPopover` の `.popover` と同パターン)。シート内 UI は private `aboutSheetNavigationChrome` に集約。(✅100% 実装完了 — v3.0.7で ViewInspector 向けに整理)
        * 例: `AboutView(content: aboutContent)` を `sheet(isPresented:)` から呼び出す。(✅100% 実装完了)

### 4.1. プラットフォーム固有 API 利用方針 `{@spec:s4-1}`

**実装状況**: ✅ **完全実装済み** - プラットフォーム固有 API の実装完了

* macOS 向け About ウィンドウでは、`NSWindow` および `NSHostingController` を利用します。(✅100% 実装完了 - `AboutWindow.swift` で実装)
  * `NSWindowDelegate` プロトコルを実装し、ウィンドウのライフサイクルを適切に管理します
  * タイトルバーの閉じるボタン (×) でウィンドウを閉じることができます
* iPadOS 向けでは、`UIViewControllerRepresentable` を利用せず、SwiftUI のネイティブ `.sheet` / `.popover` API のみで構成します。(✅100% 実装完了 - `Extensions.swift` で実装)
* 共有ロジック (ViewModel / Markdown レンダリング / リーガルテキスト I/O) は、すべて `#if canImport(SwiftUI)` ベースで共通化します。(✅100% 実装完了)

### 4.2. プロジェクト構成 `{@spec:s4-2}`

コード構造と各ファイルの責務の詳細は [architecture.md](./architecture.md) を参照してください。

```
`s2j-about-window`/
├── LICENSE
├── README.md
├┬─ docs/  # ドキュメント類
│├─ `SPEC.md`  # 本ドキュメント
│└─ `SPEC_CICD.md`  # CI/CD Workflow ドキュメント
├── package.json / package-lock.json  # Docs Linter (`@s2j/docs-linter`)、`npm run lint:docs`
├── .textlintrc.json  # textlint 設定 (Swift ドキュメント向けプリセット)
├┬─ .github/  # CI/CD
│└┬─ workflows/
│　├─ docs-lint.yml  # Markdown lint (npm)
│　├─ swift-test.yml (✅100% 実装完了)
│　└─ update-snapshots.yml  # macOS 参照 PNG 記録 (`workflow_dispatch`、macos-26)
├┬─ scripts/  # スクリプト
│└─ test-local.sh  # ローカル・テスト実行スクリプト (✅100% 実装完了 - 統合版、汎用的)
├── SampleApp.swift  # エントリー・ポイント
├── Package.swift  # Swift Package 定義 (Textual 依存、macOS 15 / iOS 18) (✅100% 実装完了)
├── project.yml  # XcodeGen 設定ファイル (✅100% 実装完了)
├┬─ Sources/
│└┬─ S2JAboutWindow/  # メイン・ソースコード
│　├─ AboutWindow.swift  # macOS: NSWindow 管理 + public API (✅100% 実装完了)
│　├─ AboutView.swift  # SwiftUI view (共通) (✅100% 実装完了)
│　├─ AboutViewModel.swift  # ViewModel (app metadata、markdown) (✅100% 実装完了)
│　├─ MarkdownView.swift  # Textual StructuredText (✅100% 実装完了)
│　├─ AboutContentView.swift  # About 本文 Markdown / JSON / RTF、`AboutContentType` (✅100% 実装完了)
│　├─ LegalTextLoader.swift  # バンドル License / Acknowledgements 読込 (✅100% 実装完了)
│　├─ LegalTextView.swift  # プレーン長文 + シート (✅100% 実装完了)
│　├─ Extensions.swift  # iPadOS 向け拡張 (✅100% 実装完了)
│　├─ PreviewContent.swift  # DEBUG: `Preview Content/` から Canvas 用 Markdown を読み込み (✅100% 実装完了)
│　└┬─ Resources/  # リソースファイル
│　　├─ AboutDefault.md  # デフォルトコンテンツ (✅100% 実装完了)
│　　├┬─ Assets.xcassets/  # アセット (✅100% 実装完了)
│　　│└─ Contents.json
│　　├─ Base.lproj/Localizable.strings  # ローカライゼーション (✅100% 実装完了)
│　　├─ en.lproj/Localizable.strings  # ローカライゼーション (✅100% 実装完了)
│　　└─ ja.lproj/Localizable.strings  # ローカライゼーション (✅100% 実装完了)
├┬─ Tests/
│└┬─ S2JAboutWindowTests/  # テストコード
│　├─ AboutViewTests.swift (✅ XCTest)
│　├─ AboutViewSnapshotTests.swift (✅ SnapshotTesting / 参照画像あり)
│　├─ AboutSheetInspectorTests.swift (✅ iOS: ViewInspector + `aboutSheet`)
│　├─ AboutContentFormatTests.swift (✅ Swift Testing: JSON / RTF / `AboutContentType`)
│　├─ LegalTextLoaderTests.swift (✅ Swift Testing)
│　├─ Resources/  # ローダー用フィクスチャ (.txt / .md)
│　└─ __Snapshots__/AboutViewSnapshotTests/  # 参照 PNG (`testAboutViewSnapshot_light` 等)
└── Preview Content/  # Xcode Canvas 用 Markdown (`AboutPreview.md` 等) (✅ 実装完了)
```

### 4.3. 主要ファイルの実装状況 `{@spec:s4-3}`

* `Package.swift` : Swift Package 定義、Textual 依存、最小 OS macOS v15 / iOS v18、リソース設定。テストのみ `swift-snapshot-testing` / ViewInspector (✅100% 実装完了)
* `project.yml` : XcodeGen 設定ファイル、macOS/iOS ターゲット定義、プラットフォーム専用スキーム定義 (✅100% 実装完了)
  * **リソース**: ターゲット直下の `resources:` は使わず、`sources` で `buildPhase: resources` を指定 (XcodeGen v2.49+)。`SampleApp` の `SampleResources` 同梱を含む。
  * **iOS 実行先**: スキーム `S2JAboutWindow-iOS` の実行先は Xcode で **iOS Simulator** を手動選択。CI、`scripts/test-local.sh` は [SPEC_CICD.md](./SPEC_CICD.md) の `xcodebuild -destination`。
  * **開発アセット**: `S2JAboutWindow-macOS` / `iOS` に `DEVELOPMENT_ASSET_PATHS: "Preview Content"` (Canvas 専用、リリースバイナリには含めない)。
  * **テスト用 SPM** (ライブラリ製品には非同梱): `SnapshotTesting` / `ViewInspector`。`Package.swift` の `S2JAboutWindowTests` と同系統のバージョン要件。
  * **ターゲット構成**:
    * `S2JAboutWindow-macOS`: macOS 向けフレームワーク
    * `S2JAboutWindow-iOS`: iOS 向けフレームワーク (署名: `CODE_SIGNING_ALLOWED: NO` — シミュレーター/ローカル向け)
    * `S2JAboutWindowTests-macOS`: macOS 向けテストバンドル (`SnapshotTesting` にリンク。`AboutViewSnapshotTests` を含む)
    * `S2JAboutWindowTests-iOS`: iOS 向けテストバンドル (`ViewInspector` にリンク。`AboutViewSnapshotTests` と `__Snapshots__` はソース除外。署名: `CODE_SIGNING_ALLOWED: NO`)
  * **スキーム構成**:
    * `S2JAboutWindow`: 統合スキーム (macOS + iOS)
    * `S2JAboutWindow-macOS`: macOS 専用スキーム (macOS ターゲットのみ)
    * `S2JAboutWindow-iOS`: iOS 専用スキーム (iOS ターゲットのみ)
  * **開発用 Xcode プロジェクト (署名・シミュレーター)**:
    * 配布の正本は **SPM** (`Package.swift`)。`project.yml` は Canvas、`ViewInspector` / スナップショット、`SampleApp` 用で、**ホストアプリへの組込みを想定しない**。
    * ローカル、CI のデフォルトは **シミュレーター/My Mac** でのビルド・テスト。`project.yml` に `DEVELOPMENT_TEAM` は書かない ([s2j-source-list](https://github.com/stein2nd/s2j-source-list) の `project.yml` と同型)。
    * iOS フレームワーク、iOS テストは `CODE_SIGNING_ALLOWED: NO` (実機配布、Archive 向けではない)。
    * `PRODUCT_BUNDLE_IDENTIFIER` はプラットフォーム別 (`…-macOS` / `…-iOS`、テストも同様)。同一 ID を macOS、iOS で共有すると、Xcode の Signing タブが **macOS** 側に寄って表示されることがある (開発用 `.xcodeproj` のみ。SPM 製品の Bundle ID には影響しない)。
    * macOS ターゲットも Team 未設定のため、Xcode Signing は **Don't Code Sign** に見えるのが正常。CI、`npm run lint:build` は `CODE_SIGNING_ALLOWED=NO` でビルド ([SPEC_CICD.md](./SPEC_CICD.md))。
    * `SampleApp` は `CODE_SIGN_STYLE: Automatic` のみ (Team なし)。macOS 上の手動確認用。**実機インストール・署名付き Archive はホストアプリ側** の責務。
* `AboutWindow.swift` : macOS 向け NSWindow 管理、showAboutWindow/closeWindow API、NSWindowDelegate 実装 (✅100% 実装完了)
* `AboutView.swift` : SwiftUI ビュー、アプリケーション・アイコン表示、アプリケーション情報表示、MarkdownView 統合 (✅100% 実装完了)
* `AboutViewModel.swift` : ViewModel、`content` / `contentType` / `effectiveContentType`、メタデータ、Bundle 拡張 (✅100% 実装完了)
* `AboutContentView.swift` : `AboutContentType` / `AboutContentFormat`、About 本文の Markdown / JSON / RTF (✅100% 実装完了)
* `MarkdownView.swift` : Textual `StructuredText`、About `.default` / リーガル `.md` は `.gitHub` + 折り返し (✅100% 実装完了)
* `LegalTextLoader.swift` / `LegalTextView.swift` : バンドル長文と About フッター連携 (✅100% 実装完了)
* `Extensions.swift` : iPadOS 向け `aboutSheet` / `aboutPopover`。`aboutSheet` は View 直下 `.sheet` + `aboutSheetNavigationChrome` (ViewInspector / CI `test-ios` 向け。v3.0.7〜3.0.9) (✅100% 実装完了)
* `PreviewContent.swift` : `#if DEBUG` のみ。`SRCROOT` またはリポジトリ相対パスから `Preview Content/*.md` を読み込み (✅100% 実装完了)
* `Preview Content/AboutPreview.md` / `MarkdownPreview.md` : Canvas 用サンプル本文 (✅100% 実装完了)
* `Resources/AboutDefault.md` : デフォルト Markdown コンテンツ (✅100% 実装完了)
* `Resources/Localizable.strings` : 英語・日本語ローカライゼーション (✅100% 実装完了)

### 4.4. アクセシビリティとローカライズ `{@spec:s4-4}`

**実装状況**: ✅ **完全実装済み** - 英語・日本語のローカライゼーション対応完了

* ローカライズ対応は、必須 (英語・日本語) の為、Base、English、Japanese を初期追加します。(✅100% 実装完了)
* `Bundle.module` 経由で `Localizable.strings` を読み込みます (SwiftPM の `resources: [.process("Resources")]`)。(✅100% 実装完了)
* Markdown のデフォルト文書 (`AboutDefault.md`) を用意し、利用側で上書き可能にします。(✅100% 実装完了)
* 文字列キー例: `"About.Title"`、`"About.NoDescription"`、`"About.Copyright"`、`"About.Close"`、`"About.Version"`、リーガル用 `About.License.Button` 等 (✅100% 実装完了)

## 5. デザイン規約 `{@spec:s5}`

**実装状況**: ⚠️ **ほぼ実装済み** - ダークモード対応、アプリケーション・アイコン自動取得が完了 (macOS は完全実装、iPadOS は要確認)

* アイコンは App アイコンから自動取得します。(✅100% 実装完了 - `NSApplication.shared.applicationIconImage` を使用、macOS 専用)
* ダークモード対応は、必須です。(✅100% 実装完了 - macOS: `Color(NSColor.windowBackgroundColor)`、iPadOS: `Color(UIColor.systemBackground)` を使用)

## 6. 使用方法 `{@spec:s6}`

**実装状況**: ✅ **完全実装済み** - 使用方法の実装完了

**macOS:**

```swift
let aboutWindow = AboutWindow()
aboutWindow.showAboutWindow(
    content: "Your content",
    contentType: .automatic, // または .markdown / .json / .rtf
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
    content: #"{"build":42}"#,
    contentType: .json,
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

## 8. テスト戦略 `{@spec:s8}`

**実装状況**: ✅ **基本完了** — XCTest / Swift Testing / Snapshot (macOS) / ViewInspector (iOS) を実装。`LegalTextView` 専用 Snapshot と `NSWindow` 全体は Backlog。

**UI テスト環境**:
* macOS: `AboutViewSnapshotTests` が `NSHostingView` 経由で `AboutView` / `MarkdownView` を画像比較 (`perceptualPrecision: 0.98`)。参照 PNG は **macos-26** の `update-snapshots` ワークフローで記録 (SnapshotTesting の「参照 OS と一致」推奨に従う)。CI (`CI=true`) では `record: .never`。
* ローカル `swift test` (macOS): スナップショット2件は OS 差分のため **XCTSkip** (`FORCE_SNAPSHOT_TESTS=1` で強制実行)。`AboutSheetInspectorTests` は `#if os(iOS)` のためコンパイルのみ。
* iPadOS: `AboutSheetInspectorTests` が ViewInspector で `aboutSheet` 内の `AboutView` を検証 (CI `test-ios` / `project.yml` の `S2JAboutWindowTests-iOS`。スナップショットソースは iOS ターゲットから除外)。
* **ViewInspector 実装制約 (v3.0.7)**: `aboutSheet` はカスタム `ViewModifier` 内の `.sheet` にしない。ViewInspector はホストビュー・チェーン上のネイティブ `.sheet` のみ検出する (`inspect().color().sheet()`)。未対応時は `Host does not have 'sheet' modifier` で失敗する。
* macOS `NSWindow` 全体のスナップショットは Backlog (View スナップショットで代替)。
* `AboutViewTests` にあった Snapshot 用プレースホルダは削除済み (正本は `AboutViewSnapshotTests`)。

**CI/CD でのテスト実行**:
* CI/CD パイプラインで自動的にテストを実行し、テスト・カバレッジを収集します。
* CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

## 9. CI / CD `{@spec:s9}`

CI/CD に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) を参照。

本セクションでは、CI/CD の概要のみを記載します。

* Swift Package のビルド成果物 (バイナリ / XCFramework) は Git 管理対象外です。
* Universal Binary 化は SwiftPM のビルドフェーズで自動処理されます。
* リリース用ビルドは GitHub Actions の CI ワークフローで生成し、Artifacts として管理します。
* 本プロジェクトでは、以下の GitHub Actions ワークフローを導入します。
  * `docs-lint.yml`: Markdown ドキュメントの表記揺れ検出 (`npm run lint:docs`) (✅100% 実装完了・テスト成功)
  * `swift-test.yml`: Swift Package のユニットテスト (macOS / iOS) およびリリースビルド (✅100% 実装完了・テスト成功)

**実装状況**: ✅ **完全実装済み・テスト成功** - CI/CD ワークフローとローカルテスト・スクリプトの実装完了、GitHub Actions「Swift Test」ワークフローと「Docs Linter」ワークフローが正常に動作し、すべてのテストとチェックが成功

## 10. 実装状況サマリー `{@spec:s10}`

本章では、「現在の実装状況」を記載します。

### 10.1. 完全実装済み機能 (100% 完了) `{@spec:s10-1}`

以下の機能は完全に実装され、テストも完了しています。

* コア機能
  * **AboutWindow.swift**:
    * macOS 向け NSWindow 管理、`showAboutWindow()` / `closeWindow()` API の実装です。
    * `NSHostingController` を使用して SwiftUI ビューを NSWindow に統合します。
    * ウィンドウサイズ: 400x500、スタイル: `.titled`、`.closable`、`.miniaturizable` を設定します。
    * ウィンドウタイトルは `NSLocalizedString("About.Title", bundle: .module)` を使用します。
    * `NSObject` を継承し、`NSWindowDelegate` プロトコルを実装してウィンドウのライフサイクルを管理します。
    * `window.isReleasedWhenClosed = false` を設定し、`window.delegate = self` でデリゲートを設定します。
    * `windowWillClose(_:)` メソッドを実装し、ウィンドウが閉じられた際に適切にクリーンアップします。
    * タイトルバーの閉じるボタン (×) でウィンドウを閉じることができます。
    * `licenseResourceName` / `acknowledgementsResourceName` によるリーガル文書シート連携。
  * **AboutView.swift**:
    * SwiftUI ビュー、アプリケーション・アイコン表示、アプリケーション情報表示、`AboutContentView` による本文表示です。
    * `@StateObject` を使用して `AboutViewModel` を管理します。
    * アプリケーション・アイコン: 64x64、角丸矩形 (`RoundedRectangle(cornerRadius: 12)`)。
    * アプリケーション情報: アプリケーション名 (`.title2`、`.bold`)、バージョン (`.subheadline`)、著作権 (`.caption`)。
    * プラットフォーム固有の背景色対応: macOS では `Color(NSColor.windowBackgroundColor)`、iPadOS では `Color(UIColor.systemBackground)` を使用。
    * プラットフォーム固有のアプリケーション・アイコン取得: macOS では `NSApplication.shared.applicationIconImage`、iPadOS では `UIImage(named:)` を使用。
    * Xcode Preview 対応 (`AboutView_Previews` — `PreviewContent.markdown(named: "AboutPreview")`)。
  * **AboutViewModel.swift**:
    * ViewModel、コンテンツ管理、アプリケーション・メタデータ管理、Bundle 拡張機能。
    * `@Published` の `content`、`public let contentType`、`effectiveContentType` と `appName` / `version` / `copyright` を管理します。
    * `loadDefaultContent()` メソッドでデフォルトコンテンツを読み込みます。
    * Bundle 拡張: `displayName`、`version`、`copyright` プロパティを追加します。
  * **MarkdownView.swift**:
    * [Textual](https://github.com/gonzalezreal/textual) `StructuredText` による Markdown 描画。
    * About 本文: `.structuredTextStyle(.default)`。バンドル Acknowledgements `.md`: `.legalDocument` で `.gitHub` + `overflowMode(.wrap)`。
    * `ScrollView` + `.textual.textSelection(.enabled)`。
    * Xcode Preview 対応 (`MarkdownView_Previews` — `PreviewContent.markdown(named: "MarkdownPreview")`)
  * **LegalTextLoader.swift** / **LegalTextView.swift**:
    * ホスト `Bundle` から License / Acknowledgements を読み込み、シートで表示 (プレーンまたは `MarkdownView`)。
    * 詳細: [legal_text_spec.md](./legal_text_spec.md)。
  * **Extensions.swift**:
    * iPadOS 向け `aboutSheet()` / `aboutPopover()` 拡張機能。
    * `aboutSheet()`: `View` エクステンション内で `sheet(isPresented:)` を直接適用。シート本体は private `aboutSheetNavigationChrome(isPresented:about:)` (`NavigationView` + クロージャで渡した `AboutView` + iOS 閉じるツールバー)。カスタム `ViewModifier` で `.sheet` を包む方式は採用しない (ViewInspector 制約。v3.0.7)。ヘルパーは引数過多を避けるため `AboutView` をクロージャで受け取る (SwiftLint `function_parameter_count`。v3.0.9)。
    * `aboutPopover()`: 400x500px の固定サイズで表示します。
* プラットフォーム対応
  * **macOS 対応**:
    * `NSWindow` および `NSHostingController` を利用した独立ウィンドウ表示を実装します。
    * `#if os(macOS)` 条件分岐で macOS 専用コードを分離します。
    * `NSApplication.shared.applicationIconImage` でアプリケーション・アイコンを取得します。
  * **iPadOS 対応**:
    * SwiftUI ネイティブ `.sheet` / `.popover` API によるモーダル表示を実装します。
    * `#if os(iOS)` 条件分岐で iOS/iPadOS 専用コードを分離します。
    * `NavigationView` と `ToolbarItem` を使用した UI 構成を実装します。
  * **マルチ・プラットフォーム対応**:
    * `#if canImport(SwiftUI)` ベースの共通化ロジック。
    * `@available(macOS 15.0, iOS 18.0, *)` でプラットフォーム要件を指定。
* リソース・ローカライゼーション
  * **Package.swift**:
    * Swift Package 定義、Textual 依存、リソース設定 (`resources: [.process("Resources")]`)。
    * macOS/iPadOS 両対応 (`.macOS("15.0")`、`.iOS("18.0")`)。
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
    * Bundle 拡張による `displayName`、`version`、`copyright` を自動取得します。
* コンテンツ形式サポート
  * **Markdown 形式のコンテンツサポート**:
    * `MarkdownView.swift` (Textual) で実装完了。GFM 表・コードフェンス (リーガル文書は折り返し) を Acknowledgements 向けにサポート。
  * **JSON / RTF (Should)**:
    * `AboutContentView.swift` / `AboutContentFormat` — JSON は整形表示、RTF は `AttributedString`、`.automatic` で判別不能時は Markdown (✅実装完了)。
    * 公開 `AboutContentType` — `AboutView` / `AboutWindow` / `aboutSheet` / `aboutPopover` の `contentType` 引数 (デフォルト `.automatic`)。
  * **バンドルリーガルテキスト**:
    * `LegalTextLoader` / About フッター / シート表示 — 実装完了 (2.0.13〜3.0.1)。
* 開発体験 (Xcode Preview)
  * **Preview Content**:
    * リポジトリ直下 `Preview Content/` (`AboutPreview.md`、`MarkdownPreview.md`)。
    * `PreviewContent.swift` が Xcode (`SRCROOT`) または SwiftPM 開発時の相対パスから読み込み。
    * `project.yml` の `DEVELOPMENT_ASSET_PATHS` と XcodeGen 生成プロジェクトで Canvas と連携。

### 10.2. ほとんど実装済み機能 (85-95% 完了) `{@spec:s10-2}`

以下の機能は実装がほぼ完了していますが、一部の機能やテストが未完了です。

* テストコード
  * **AboutViewTests.swift** (XCTest): ユニットテストのみ (Snapshot プレースホルダは廃止)。
    * ✅ `AboutViewModel` の初期化テスト (デフォルト値、nil 値の両方をテスト)。
    * ✅ `MarkdownView` / `AboutView` の作成テスト。
    * ✅ `AboutWindow` の作成・表示・閉じるテスト (macOS)。
  * **AboutViewSnapshotTests.swift** (XCTest + SnapshotTesting): **macOS のみ** (`swift test` / `test-macos`)。`testAboutViewSnapshot_light` / `testMarkdownViewSnapshot_light`、参照 `__Snapshots__/AboutViewSnapshotTests/*.png`。
  * **LegalTextLoaderTests.swift** (Swift Testing): ローダー・拡張子探索・`usesMarkdownRendering` — ✅ 実装済み。
  * **AboutContentFormatTests.swift** (Swift Testing): JSON / RTF 判別と整形 — ✅ 実装済み。
  * **AboutSheetInspectorTests.swift** (iOS / XCTest + ViewInspector): `aboutSheet` 内の `AboutView` — ✅ 実装済み (`test-ios` / XcodeGen。`project.yml` で ViewInspector をリンク)。`Color.clear.aboutSheet(...)` ホストで `inspect().color().sheet()` → `find(AboutView.self)`。

### 10.3. 未実装機能 `{@spec:s10-3}`

以下の機能は仕様に記載されていますが、まだ実装されていません。

* テスト・品質保証
  * **UI テスト・スナップショットテスト**:
    * macOS `NSWindow` 単体の Snapshot は未実装 (View スナップショットは完了)。

### 10.4. 実装完了率 `{@spec:s10-4}`

**実装完了率の算出方法**:
* 各機能カテゴリーの実装状況を評価し、重み付け平均で全体の完了率を算出。
* 完全実装済み (100%)、ほとんど実装済み (90%)、未実装 (0%) として計算。

**カテゴリー別完了率**:

| カテゴリー | 完了率 | 備考 |
| --- | --- | --- |
| コア機能 | 100% | AboutWindow、AboutView、AboutViewModel、MarkdownView (Textual)、LegalText*、Extensions 実装完了 |
| プラットフォーム対応 | 100% | macOS と iPadOS の両方で完全実装 (プラットフォーム固有 API を適切に使用) |
| リソース・ローカライゼーション | 100% | 英語・日本語ローカライゼーション、デフォルトコンテンツ実装完了、`Bundle.module` 経由で適切に読み込み |
| UI/UX 機能 | 100% | macOS と iPadOS の両方でダークモード・アプリケーション・アイコン自動取得を実装完了 |
| CI/CD | 100% | GitHub Actions ワークフローとローカル・テストスクリプトの実装完了 (詳細は [SPEC_CICD.md](./SPEC_CICD.md) を参照) |
| コンテンツ形式サポート | 100% | Markdown + JSON 整形 + RTF (`AboutContentView`) |
| テスト・品質保証 | 85% | XCTest + Snapshot (`AboutViewSnapshotTests`) + Swift Testing + iOS ViewInspector。`NSWindow` スナップショットは Backlog |
| バンドルリーガル表示 | 100% | Issue #17完了 ([legal_text_spec.md](./legal_text_spec.md)) |
| 開発体験 (Xcode Preview) | 100% | `Preview Content/`、`PreviewContent.swift`、詳細は [status.md](./status.md) §開発体験 |

**全体実装の完了率**: **約92%** (コア、リーガル、Should コンテンツ、Canvas、基本 Snapshot は完了。`NSWindow` スナップショットが残り)
* コア機能 (About Window の基本機能) は、100% 実装完了
  * macOS での動作は完全に実装済み。
  * iPadOS での動作も完全に実装済み (プラットフォーム固有 API を適切に使用)。
* プラットフォーム対応は、100% 実装完了 (macOS と iPadOS の両方で完全実装)。
* CI/CD は、100% 実装完了・テスト成功 (GitHub Actions ワークフローとローカル・テストスクリプトの実装完了、GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功)。
* JSON / RTF (Should) は `AboutContentView` で実装済み。高度な JSON スキーマ専用 UI などは Backlog。
* テストコードについて: XCTest ・ Snapshot ・ ViewInspector (iOS) を実装済み。`LegalTextView` / `NSWindow` の追加スナップショットは Backlog。

### 10.5. 品質評価 `{@spec:s10-5}`

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
    * バンドルリーガルテキストは空・ロード失敗を UI で明示。About 本文は Textual に委譲。
  * ✅ **ドキュメント**:
    * 主要なクラス・メソッドに JSDoc スタイルのコメントを実装します。
    * パラメータ、戻り値、説明が適切に記載されています。
  * ✅ **開発体験**:
    * `Preview Content/` と `#if DEBUG` の `PreviewContent` / `PreviewProvider` により、インライン文字列に依存しない Canvas 確認が可能。
* テスト品質
  * ✅ **ユニットテスト**:
    * `AboutViewTests.swift` (XCTest) と `LegalTextLoaderTests.swift` (Swift Testing)。
  * ✅ **UI テスト (基本)**:
    * `AboutView` / `MarkdownView` の画像スナップショットと iOS `aboutSheet` の ViewInspector。
  * ⚠️ **UI テスト (拡張)**:
    * `NSWindow` / `LegalTextView` の Snapshot は未実装です。
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
    * Textual `StructuredText` による Markdown レンダリング (About / リーガル文書でスタイル分岐)。
* 総合評価
  * **総合品質**:
    * **良好** - コア機能は高品質に実装されており、基本的な用途には十分に対応可能。
  * **改善点**:
    * `NSWindow` / `LegalTextView` の Snapshot 拡張、JSON/RTF コンテンツ、テスト・カバレッジの向上により、さらなる品質向上が期待できます。

## 11. Backlog `{@spec:s11}`

本章では、「今後の予定」を記載します。

### 11.0. 完了済み (参照) `{@spec:s11-0}`

* **バンドル同梱 License / Acknowledgements** ([#17](https://github.com/stein2nd/s2j-about-window/issues/17)・クローズ済み)
  * 仕様: [legal_text_spec.md](./legal_text_spec.md)。リリース: v2.0.13〜 **v3.0.1** (Textual、コードブロック折り返し)。
* **Preview Content** — `Preview Content/`、`DEVELOPMENT_ASSET_PATHS`、`PreviewContent.swift` (v3.0.5)。
* **Snapshot / UI テスト (初版)** — `AboutViewSnapshotTests`、`AboutSheetInspectorTests`、テスト依存 (`swift-snapshot-testing` / ViewInspector)。`NSWindow` スナップショットは未。
* **CI テスト安定化 (v3.0.7)** — `macos-26` 向けスナップショット再記録、`update-snapshots` 終了コード許容、`project.yml` で `test-ios` に ViewInspector を配線 (iOS からスナップショットテスト除外)。`aboutSheet` を View 直下 `.sheet` に変更し `AboutSheetInspectorTests` を安定化。
* **Should コンテンツ形式 (JSON / RTF / `AboutContentType`)** — `AboutContentView` / `AboutContentFormat`、`AboutContentFormatTests` (v3.0.10)。

### 11.1. 短期での改善予定 (1-3ヵ月) `{@spec:s11-1}`

品質保証と開発体験の向上を目的とした改善を、優先的に実施します。

* **スナップショット拡張・カバレッジ**
  * `NSWindow` 表示のスナップショット、`LegalTextView` の Light / Dark。
  * テスト・カバレッジの継続向上。

### 11.2. 中期での改善予定 (3-6ヵ月) `{@spec:s11-2}`

機能拡張を目的とした改善を実施します。

* **About ヘッダーパネル** ([#18](https://github.com/stein2nd/s2j-about-window/issues/18)・仕様確定)
  * [about_header_panel_spec.md](./about_header_panel_spec.md) — `AboutHeaderOptions` / `classicHorizontal`、ビルド番号、`primaryLink` (フェーズ1→3、opt-in)。
* **コンテンツ形式の拡張**
  * JSON スキーマに沿った構造化 UI (表形式キー表示など)。
  * HTML インラインなど Markdown 以外のリッチ本文 (現行 Should は Markdown / 整形 JSON / RTF 文字列)。

### 11.3. 長期での改善予定 (6ヵ月以上) `{@spec:s11-3}`

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
* **macOS 補助 `NSWindow` による License 表示**
  * [legal_text_spec.md](./legal_text_spec.md) Backlog。初版は `.sheet` に統一。

---

## Appendix A: Xcode プロジェクト作成ウィザード推奨選択肢リスト `{@spec:s-appendix-a-xcode}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

**補足**:
* 本プロジェクトは Swift Package として他アプリケーションに組み込まれることを前提としているため、Xcode ウィザードで「App」テンプレートを選ぶ必要はありません。
* macOS/iPadOS 両対応の Swift Package として作成する場合は、「Framework」または「Swift Package」テンプレートを使用し、対応プラットフォームを macOS v15.0、iOS v18.0と指定します (Textual 依存)。
* ドキュメント品質 (表記揺れや用語統一) は npm パッケージ [`@s2j/docs-linter`](https://www.npmjs.com/package/@s2j/docs-linter) と `docs-lint.yml` で CI 検証します。

### 1. テンプレート選択 `{@spec:s1-2}`

* **Platform**: Multiplatform (macOS、iPadOS)
* **Template**: Framework または Swift Package

### 2. プロジェクト設定 `{@spec:s2-3}`

| 項目 | 推奨値 | 理由 |
| --- | --- | --- |
| Product Name | `s2j-about-window` | `SPEC.md` のプロダクト名と一致 |
| Team | **ホストアプリ** 配布時に Apple ID で設定。本リポジトリの `project.yml` には書かない (開発用 Xcode はシミュレーター/署名なし。§4.3参照) |
| Organization Identifier | `com.s2j` | ドメイン逆引き規則、一貫性確保 |
| Interface | SwiftUI | SwiftUI ベースを前提 |
| Language | Swift (Swift v6.3) | Xcode v26.5に同梱される Swift バージョン (Objective-C は不要) |
| Use Core Data | Off | データ永続化不要 |
| Include Tests | On | `SPEC.md` にもとづきテストを考慮 |
| Include CloudKit | Off | 不要 |
| Include Document Group | Off | Document-based App ではない |
| Source Control | On (Git) | `SPEC.md` / GitHub 運用をリンクさせるため |

### 3. デプロイ設定 `{@spec:s3-7}`

| 項目 | 推奨値 | 理由 |
| --- | --- | --- |
| macOS Deployment Target | macOS v15.0以上 | Textual / 公開 API `@available` と一致 |
| iOS Deployment Target | iPadOS v18.0以上 | Textual / 公開 API `@available` と一致 |

### 4. 実行確認の環境 (推奨) `{@spec:s4-5}`

| プラットフォーム | 実行確認ターゲット | 理由 |
| --- | --- | --- |
| macOS | macOS v15以降 | NSWindow、リーガルシートの動作確認 |
| iPadOS | iPadOS v18以降 (iPad シミュレーター) | `.sheet` / `.popover`・リーガルシートの UI 確認 |

### 5. CI ワークフロー補足 `{@spec:s5-2}`

**実装状況**: ✅ **完全実装済み・テスト成功** - CI ワークフローの実装完了、GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功

CI/CD に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) を参照。
