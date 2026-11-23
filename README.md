# S2J About Window

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![Xcode](https://img.shields.io/badge/Xcode-26.5-blue?logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Swift](https://img.shields.io/badge/Swift-6.3-blue?logo=Swift&logoColor=white)](https://www.swift.org)
[![macOS](https://img.shields.io/badge/macOS-15.0+-blue?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![iPadOS](https://img.shields.io/badge/iOS-18.0+-blue?logo=apple&logoColor=white)](https://www.apple.com/ipados/)

## Description

<!-- 
S2J About Window is a modern, SwiftUI-based library that provides a customizable About Window for macOS and iPadOS applications. This library was ported from the popular [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) project, bringing its functionality to the SwiftUI ecosystem.

The library offers a flexible and easy-to-use API for displaying application information, credits, and other content in a native About Window. It supports multiple content formats including Markdown, JSON, and RTF, making it easy to create rich, formatted content for your application's About window.
 -->

S2J About Window は、macOS および iPadOS アプリケーション向けのカスタマイズ可能な About ウィンドウを提供する、モダンな SwiftUI ベースのライブラリです。本ライブラリは、人気の [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) プロジェクトから移植され、その機能を SwiftUI エコシステムにもたらしています。

本ライブラリは、ネイティブな About ウィンドウでアプリケーション情報、クレジット、その他のコンテンツを表示するための柔軟で使いやすい API を提供します。Markdown、JSON、RTF など複数のコンテンツ形式をサポートしており、アプリケーションの About ウィンドウ用のリッチなフォーマット済みコンテンツを簡単に作成できます。

## Features

<!-- 
* **Cross-platform**: macOS v15.0+ / iOS v18.0+. macOS uses `AboutWindow` (`NSWindow`), while iPadOS uses `aboutSheet` / `aboutPopover`
* **SwiftUI Native**: `AboutView` / `AboutViewModel`, Markdown via Textual, and `AboutContentView` for the body text
* **Content Formats**: Markdown (Textual), JSON (formatted display), RTF (`AttributedString`). Public `AboutContentType` (`.automatic` / `.markdown` / `.json` / `.rtf`)
* **Bundled License / Acknowledgments**: `licenseResourceName` / `acknowledgementsResourceName`; `.md` files use `MarkdownView` (GFM tables and code wrapping)
* **Localization**: English and Japanese (`Localizable.strings`; default `AboutDefault.md`)
* **Dark Mode**: Adapts to the system background color
* **Quality**: XCTest / Swift Testing, macOS snapshots, and ViewInspector for iOS (`aboutSheet`). CI: GitHub Actions `Swift Test` / `Lint Docs`
 -->

* **クロス・プラットフォーム**: macOS v15.0+ / iOS v18.0+。macOS は `AboutWindow` (`NSWindow`)、iPadOS は `aboutSheet` / `aboutPopover`
* **SwiftUI ネイティブ**: `AboutView` / `AboutViewModel`、Textual による Markdown、本文は `AboutContentView`
* **コンテンツ形式**: Markdown (Textual)、JSON (整形表示)、RTF (`AttributedString`)。公開 `AboutContentType` (`.automatic` / `.markdown` / `.json` / `.rtf`)
* **バンドル License / Acknowledgements**: `licenseResourceName` / `acknowledgementsResourceName`、`.md` は `MarkdownView` (GFM 表・コード折り返し)
* **ローカライズ**: 英語・日本語 (`Localizable.strings`、デフォルト `AboutDefault.md`)
* **ダークモード**: システム背景色に追従
* **品質**: XCTest / Swift Testing、macOS スナップショット、iOS は ViewInspector (`aboutSheet`)。CI: GitHub Actions `Swift Test` / `Lint Docs`

## License

<!-- 
This project is licensed under the GPL v3.0 or later. For details, please refer to the [LICENSE](LICENSE) file.
 -->

本プロジェクトは GPL v3.0以降ライセンスの下で提供されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## Support and Contact

<!-- 
For support, feature requests, or bug reports, please visit the [GitHub Issues](https://github.com/stein2nd/s2j-about-window/issues) page.
 -->

サポート、機能リクエスト、またはバグ報告については、[GitHub Issues](https://github.com/stein2nd/s2j-about-window/issues) ページをご覧ください。

---

## Installation

### Requirements

* macOS v15.0+ / iOS v18.0+
* Xcode v26.5+
* Swift v6.3+

### Swift Package Manager

<!-- 
Add the following to your `Package.swift` file.
 -->

`Package.swift` ファイルに以下を追加します。

```swift
dependencies: [
    .package(url: "https://github.com/stein2nd/s2j-about-window.git", from: "3.0.10")
]
```

<!-- 
Or add it through Xcode:
 -->

あるいは Xcode から追加します。

<!-- 
1. File → Add Package Dependency
2. Enter the repository URL: `https://github.com/stein2nd/s2j-about-window.git`
3. Select a version and add it to the target
 -->

1. ファイル → パッケージ依存関係を追加
2. リポジトリ URL を入力: `https://github.com/stein2nd/s2j-about-window.git`
3. バージョンを選択し、ターゲットに追加

## Usage

### macOS

```swift
import S2JAboutWindow

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Your app setup
    }
    
    @IBAction func showAboutWindow(_ sender: Any?) {
        let aboutWindow = AboutWindow()
        aboutWindow.showAboutWindow(
            content: """
            # My App

            This is a sample about window content.
            """,
            contentType: .automatic,
            appName: "My App",
            version: "1.0.0",
            copyright: "© 2024 My Company",
            licenseResourceName: "LICENSE",
            acknowledgementsResourceName: "ACKNOWLEDGEMENTS.md"
        )
    }
}
```

<!-- 
Add `LICENSE` (or `LICENSE.txt`) to the application target's **Copy Bundle Resources**. A **License…** button will appear in the “About” section, and you can view the full text offline in a sheet.
 -->

アプリケーションターゲットの **Copy Bundle Resources** に `LICENSE` (または `LICENSE.txt`) を追加します。About に **License…** ボタンが表示され、シートで全文をオフライン閲覧できます。

```swift
AboutView(
    content: aboutMarkdown,
    licenseResourceName: "LICENSE",
    acknowledgementsResourceName: "ACKNOWLEDGEMENTS.md"
)
```

### iPadOS

```swift
import SwiftUI
import S2JAboutWindow

struct ContentView: View {
    @State private var showAbout = false
    
    var body: some View {
        VStack {
            Button("About") {
                showAbout = true
            }
        }
        .aboutSheet(
            isPresented: $showAbout,
            content: "# My App\n\nAbout text in Markdown.",
            contentType: .automatic,
            appName: "My App",
            version: "1.0.0",
            copyright: "© 2024 My Company"
        )
    }
}
```

### Using Popover (iPadOS)

```swift
.aboutPopover(
    isPresented: $showAbout,
    content: "Your about content here",
    contentType: .automatic,
    appName: "My App"
)
```

## Content Formats

<!-- 
`AboutContentView` displays the main text. The `contentType` options are as follows:

| `AboutContentType` | Behavior |
| --- | --- |
| `.automatic` (default) | Inferred as Markdown, JSON, or RTF based on the header and structure. Invalid JSON is displayed as Markdown |
| `.markdown` | Always Textual (`MarkdownView`) |
| `.json` | Formatted using `JSONSerialization` (monospace). If parsing fails, the raw string is displayed in monospace |
| `.rtf` | Displays RTF as an `AttributedString`. If parsing fails, it falls back to Markdown |

You can check the detection result using `AboutContentType.effective(for:requested:)` or `AboutViewModel.effectiveContentType`.
 -->

`AboutContentView` が本文を表示します。`contentType` は次のとおりです。

| `AboutContentType` | 挙動 |
| --- | --- |
| `.automatic` (デフォルト) | 先頭・構造から Markdown / JSON / RTF を推定。不正 JSON は Markdown として表示 |
| `.markdown` | 常に Textual (`MarkdownView`) |
| `.json` | `JSONSerialization` で整形 (等幅)。パース失敗時は生文字列を等幅表示 |
| `.rtf` | RTF を `AttributedString` で表示。パース失敗時は Markdown にフォールバック |

推定結果は `AboutContentType.effective(for:requested:)` または `AboutViewModel.effectiveContentType` で確認できます。

### Markdown

```swift
let content = """
# About This App

This is **bold** and *italic* text.

## Features
- Feature 1
- Feature 2

[Visit our website](https://example.com)
"""
```

<!-- 
`MarkdownView` renders using [Textual](https://github.com/gonzalezreal/textual) `StructuredText`. The main text uses `.default`, while the bundled **Acknowledgements** (`.md`) uses GitHub-style formatting (**GFM tables**, fenced code, and line breaks in long `` ```text ``).

**Deprecated:** Remote images (`![](https://...)`) in the Acknowledgements, which are intended for offline use — Textual may attempt to fetch them over the network. We recommend using text-only links within the application bundle.

**Not supported or deprecated:** Mermaid and other diagramming DSLs, embedded HTML, and any content intended for web rendering.
 -->

`MarkdownView` は [Textual](https://github.com/gonzalezreal/textual) の `StructuredText` でレンダリングします。About 本文は `.default`、バンドル **Acknowledgements** (`.md`) は GitHub 風スタイル (**GFM 表**、フェンス付きコード、長い `` ```text `` の折り返し) です。

**非推奨:** オフライン想定の Acknowledgements でのリモート画像 (`![](https://...)`) — Textual がネットワーク経由でそれらを取得しようとする可能性があります。アプリケーションバンドル内では、テキストのみの通知の使用を推奨します。

**非対応・非推奨:** mermaid その他の図形 DSL、埋め込み HTML、および任意の Web レンダリングを目的としたコンテンツ。

### JSON

```swift
let metadata = #"{"name":"My App","version":"1.0.0"}"#
AboutView(content: metadata, contentType: .json)
// Even when set to “.automatic,” if the line starts with { or [, it is formatted and displayed as JSON.
```

### RTF

```swift
let rtf = "{\\rtf1\\ansi\\b About\\b0\\line Sample text}"
AboutView(content: rtf, contentType: .rtf)
```

## Localization

<!-- 
The library includes built-in localization features for the following languages.
 -->

ライブラリには、以下の言語のローカライズ機能が組み込まれています。

* English (en)
* Japanese (ja)

<!-- 
You can add your own localization by including a `Localizable.strings` file in the application bundle.
 -->

アプリケーション・バンドルに `Localizable.strings` ファイルを追加することで、独自のローカライズを追加できます。

## Customization

### Default Content

<!-- 
You can provide default content by including an `AboutDefault.md` file in the application bundle.
 -->

アプリケーション・バンドルに `AboutDefault.md` ファイルを含めることで、デフォルト・コンテンツを提供できます。

```markdown
# About This App

Your default about content here.
```

### Styling

<!-- 
The “About” window automatically adapts to the application's appearance, including support for dark mode.
 -->

About ウィンドウは、ダークモード対応を含め、アプリケーションの見た目に自動的に適応します。

## API Reference

### AboutContentType

```swift
public enum AboutContentType {
    case automatic  // Infer Markdown / JSON / RTF from the Header and Structure
    case markdown
    case json
    case rtf

    public static func effective(for content: String, requested: AboutContentType = .automatic) -> AboutContentType
}
```

<!-- 
`AboutViewModel.effectiveContentType` returns the result of the estimation when set to `.automatic`.
 -->

`AboutViewModel.effectiveContentType` は `.automatic` 時の推定結果を返します。

### AboutWindow (macOS)

```swift
public class AboutWindow {
    public init()
    public func showAboutWindow(
        content: String,
        contentType: AboutContentType = .automatic,
        appName: String? = nil,
        version: String? = nil,
        copyright: String? = nil,
        licenseResourceName: String? = nil,
        acknowledgementsResourceName: String? = nil,
        resourceBundle: Bundle = .main
    )
    public func closeWindow()
}
```

### AboutView (SwiftUI)

```swift
public struct AboutView: View {
    public init(
        content: String,
        contentType: AboutContentType = .automatic,
        appName: String? = nil,
        version: String? = nil,
        copyright: String? = nil,
        licenseResourceName: String? = nil,
        acknowledgementsResourceName: String? = nil,
        resourceBundle: Bundle = .main
    )
}
```

### LegalTextView / LegalTextLoader

```swift
public enum LegalTextKind { case license, acknowledgements }
public enum LegalTextContent { case plainText(String), empty, loadFailed }
public enum LegalTextLoader {
    public static func load(bundle: Bundle, resourceName: String, kind: LegalTextKind, ...) -> LegalTextLoadResult
}
public struct LegalTextView: View { /* plain scrollable text */ }
```

### Extensions

```swift
// iPadOS Sheet
func aboutSheet(
    isPresented: Binding<Bool>,
    content: String,
    contentType: AboutContentType = .automatic,
    appName: String? = nil,
    version: String? = nil,
    copyright: String? = nil,
    licenseResourceName: String? = nil,
    acknowledgementsResourceName: String? = nil,
    resourceBundle: Bundle = .main
) -> some View

// iPadOS Popover
func aboutPopover(/* same optional legal-text parameters */) -> some View
```

## Testing

<!-- 
| Type | Test | Execution |
| --- | --- | --- |
| Unit | `AboutViewTests` (XCTest) | `swift test` (macOS) |
| Loader | `LegalTextLoaderTests` (Swift Testing) | Same as above |
| Content Format | `AboutContentFormatTests` (Swift Testing) | Same as above |
| Snapshot | `AboutViewSnapshotTests` | CI `test-macos` (locally, `XCTSkip` is used by default; forced with `FORCE_SNAPSHOT_TESTS=1`) |
| iOS UI | `AboutSheetInspectorTests` (ViewInspector) | CI `test-ios` (`xcodegen` → `S2JAboutWindowTests-iOS`) |
 -->

| 種別 | テスト | 実行 |
| --- | --- | --- |
| ユニット | `AboutViewTests` (XCTest) | `swift test` (macOS) |
| ローダー | `LegalTextLoaderTests` (Swift Testing) | 同上 |
| 本文形式 | `AboutContentFormatTests` (Swift Testing) | 同上 |
| スナップショット | `AboutViewSnapshotTests` | CI `test-macos` (ローカルは原則 `XCTSkip`、`FORCE_SNAPSHOT_TESTS=1` で強制) |
| iOS UI | `AboutSheetInspectorTests` (ViewInspector) | CI `test-ios` (`xcodegen` → `S2JAboutWindowTests-iOS`) |

```zsh
swift test
swift test --enable-code-coverage
```

<!-- 
See the snapshot reference. PNGs are recorded in [`update-snapshots`](.github/workflows/update-snapshots.yml) for **macos-26**. To re-record them, consider setting `SNAPSHOT_TESTING_RECORD=all`.
 -->

スナップショット参照 PNG は **macos-26** の [`update-snapshots`](.github/workflows/update-snapshots.yml) で記録します。再記録は `SNAPSHOT_TESTING_RECORD=all` を検討してください。

<!-- 
Quality gate (recommended before committing):
 -->

品質ゲート (コミット前推奨):

```zsh
npm run lint:docs    # Markdown
npm run lint:swift   # SwiftLint / SwiftFormat / Periphery (xcodegen 含む)
```

### Local Testing Before Commit

<!-- 
Before committing, you can run the same tests locally as in CI/CD:
 -->

コミット前に、CI/CD と同じテストをローカルで実行できます:

```zsh
# Execute Directly
./scripts/test-local.sh

# Run from an npm script
npm run test:local
```

<!-- 
This script performs the following actions:
* Runs macOS tests
* Generates an Xcode project and runs tests (if `project.yml` exists):
  * Generates an Xcode project using `xcodegen generate`
  * Automatically selects the platform-specific scheme (`S2JAboutWindow-macOS` for macOS tests and `S2JAboutWindow-iOS` for iOS tests)
  * Runs tests for each platform independently 
* Checks for and launches the iOS simulator:
  * Automatically detects available simulators
  * Correctly extracts the device ID in UUID format
  * Skips if already running; automatically launches if not
* Attempts to run iOS tests (if Xcode is available)
* Displays helpful error messages when tests fail
 -->

このスクリプトは、以下を実行します:
* macOS テストの実行
* Xcode プロジェクトの生成とテスト (`project.yml` が存在する場合):
  * `xcodegen generate` で Xcode プロジェクトを生成
  * プラットフォーム専用スキームの自動選択 (macOS テスト時は `S2JAboutWindow-macOS`、iOS テスト時は `S2JAboutWindow-iOS`)
  * 各プラットフォームのテストを独立して実行
* iOS シミュレーターの確認と起動:
  * 利用可能なシミュレーターを自動検出
  * デバイス ID を UUID 形式で正しく抽出
  * すでに起動済みの場合はスキップ、未起動の場合は自動起動
* iOS テストの実行を試行 (Xcode が利用可能な場合)
* テスト失敗時の有用なエラー・メッセージの表示

<!-- 
This script is versatile and can be used in other Swift Package Manager projects as well.
 -->

このスクリプトは汎用的で、他の Swift Package Manager プロジェクトでも使用できます。

### How to Customize

<!-- 
**Priority**: The order is as follows.
 -->

**優先順位**: 下記の順番です。

<!-- 
1. Command-line arguments
2. Auto-detection (from Package.swift)
3. Environment variables
4. Default values
 -->

1. コマンドライン引数
2. 自動検出 (Package.swift から)
3. 環境変数
4. デフォルト値

#### Specified via command-line arguments

```zsh
# Passing Arguments from an npm Script
npm run test:local -- --skip-ios
npm run test:local -- --scheme-name MyApp --ios-device "iPhone 15"

# Execute Directly
./scripts/test-local.sh --skip-ios
./scripts/test-local.sh --scheme-name MyApp --ios-device "iPhone 15" --ios-version "16.0"
```

<!-- 
Available options:
 -->

利用可能なオプション:

<!-- 
* `-s, --scheme-name <name>`: Xcode scheme name
* `-d, --ios-device <device>`: iOS/iPadOS simulator device name
* `-v, --ios-version <version>`: Minimum iOS/iPadOS version
* `--skip-ios`: Skip iOS/iPadOS tests
* `--enable-xcode-project`: Enable Xcode project generation and testing
* `--xcode-project-name <name>`: Xcode project name
* `--xcodegen-auto-install`: Automatically install `xcodegen`
* `-h, --help`: Display help
 -->

* `-s, --scheme-name <name>`: Xcode スキーム名
* `-d, --ios-device <device>`: iOS/iPadOS シミュレーターデバイス名
* `-v, --ios-version <version>`: iOS/iPadOS 最小バージョン
* `--skip-ios`: iOS/iPadOS テストをスキップ
* `--enable-xcode-project`: Xcode プロジェクト生成とテストを有効化
* `--xcode-project-name <name>`: Xcode プロジェクト名
* `--xcodegen-auto-install`: `xcodegen` を自動インストール
* `-h, --help`: ヘルプを表示

#### Specify via an environment variable

```zsh
# Customize via Environment Variables (Arguments and auto-detection take precedence)
SCHEME_NAME="MyPackage" IOS_DEVICE="iPhone 15" IOS_VERSION="16.0" ./scripts/test-local.sh
```

<!-- 
Available environment variables:
 -->

利用可能な環境変数:

<!-- 
* `SCHEME_NAME`: Xcode scheme name (default: automatically detected from `Package.swift`)
* `IOS_DEVICE`: iOS simulator or device name (default: “iPad Pro”)
* `IOS_VERSION`: Minimum iOS version (default: “17.0”)
* `SKIP_IOS_TESTS`: Set to “true” to skip iOS tests
* `ENABLE_XCODE_PROJECT`: Set to “true” to enable Xcode project generation and testing
* `XCODE_PROJECT_NAME`: Xcode project name (default: automatically detected)
* `XCODEGEN_AUTO_INSTALL`: Set to “true” to automatically install `xcodegen`
 -->

* `SCHEME_NAME`: Xcode スキーム名 (デフォルト: Package.swift から自動検出)
* `IOS_DEVICE`: iOS シミュレーター・デバイス名 (デフォルト: "iPad Pro")
* `IOS_VERSION`: iOS 最小バージョン (デフォルト: "17.0")
* `SKIP_IOS_TESTS`: iOS テストをスキップする場合は "true"
* `ENABLE_XCODE_PROJECT`: Xcode プロジェクト生成とテストを有効にする場合は "true"
* `XCODE_PROJECT_NAME`: Xcode プロジェクト名 (デフォルト: 自動検出)
* `XCODEGEN_AUTO_INSTALL`: `xcodegen` を自動インストールする場合は "true"

## Development

### Project Structure

<!-- 
This project follows the standard Swift Package Manager structure.
 -->

このプロジェクトは標準的な Swift Package Manager の構造に従っています。

<!-- 
* `Sources/S2JAboutWindow/` — `AboutWindow` / `AboutView` / `AboutContentView` / `MarkdownView` / `LegalText*` / `Extensions.swift`, and others
* `Tests/S2JAboutWindowTests/` — Tests for the items in the table above, `__Snapshots__/` (macOS only)
* `Preview Content/` — Markdown for Xcode Canvas (not included in the release)
* `Package.swift` — SPM (Textual; for SnapshotTesting and ViewInspector testing)
* `project.yml` — XcodeGen (`npm run xcode:generate`; for ViewInspector iOS testing)
 -->

* `Sources/S2JAboutWindow/` — `AboutWindow` / `AboutView` / `AboutContentView` / `MarkdownView` / `LegalText*` / `Extensions.swift` ほか
* `Tests/S2JAboutWindowTests/` — 上表のテスト、`__Snapshots__/` (macOS のみ)
* `Preview Content/` — Xcode Canvas 用 Markdown (配布外)
* `Package.swift` — SPM (Textual; テスト用 SnapshotTesting / ViewInspector)
* `project.yml` — XcodeGen (`npm run xcode:generate`、iOS テスト用 ViewInspector)

### Setting Up Development Environment

<!-- 
To set up the development environment for this project, follow the steps below.
 -->

このプロジェクトの開発環境をセットアップするには、以下の手順を実行してください。

<!-- 
1. Clone the repository:
 -->
1. リポジトリをクローンします:

   ```zsh
   git clone https://github.com/stein2nd/s2j-about-window.git
   cd s2j-about-window
   ```

<!-- 
2. Open the project in Xcode:
 -->
2. Xcode でプロジェクトを開きます:

   ```zsh
   open Package.swift
   ```

<!-- 
To use the previews for `AboutView` and `MarkdownView` in SwiftUI **Canvas**, generate the project using XcodeGen and then open it.
 -->
   SwiftUI **Canvas** で `AboutView` / `MarkdownView` のプレビューを使う場合は、XcodeGen でプロジェクトを生成してから開きます。

   ```zsh
   npm run xcode:generate
   open s2j-about-window.xcodeproj
   ```

<!-- 
The preview text is located in `Preview Content/*.md` in the root directory of the repository (loaded by `PreviewContent.swift`).
 -->
   プレビュー本文はリポジトリ直下の `Preview Content/*.md` です (`PreviewContent.swift` が読み込み)。

<!-- 
3. Build the project:
 -->
3. プロジェクトをビルドします:

   ```zsh
   swift build
   ```

<!-- 
4. Run the test:
 -->
4. テストを実行します:

   ```zsh
   swift test
   ```

### Building and Testing

```zsh
# SPM
swift build
swift test --enable-code-coverage

# Local Execution Similar to CI (macOS + iOS, if desired)
npm run test:local
# iOS を含める例: npm run test:local:iOSfull

# Sample macOS App (After XcodeGen)
npm run lint:build
```

<!-- 
Testing on the iOS Simulator requires the `xcodegen`-generated project and the `S2JAboutWindow-iOS` scheme. For details, see [docs/SPEC_CICD.md](docs/SPEC_CICD.md) and `npm run test:local -- --help`.
 -->

iOS シミュレーター上のテストは `xcodegen` 生成プロジェクトと `S2JAboutWindow-iOS` スキームが必要です。詳細は [docs/SPEC_CICD.md](docs/SPEC_CICD.md) と `npm run test:local -- --help` を参照してください。

## Contributing

<!-- 
We welcome your contributions. Please follow these steps:
 -->

貢献をお待ちしています。以下の手順に従ってください。

<!-- 
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -m ‘Add some amazing feature’`).
4. Push to the feature branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.
 -->

1. リポジトリをフォークしてください。
2. 機能ブランチを作成してください (`git checkout -b feature/amazing-feature`)。
3. 変更をコミットしてください (`git commit -m 'Add some amazing feature'`)。
4. 機能ブランチにプッシュしてください (`git push origin feature/amazing-feature`)。
5. Pull Request を開いてください。

<!-- 
*For detailed information, please refer to the [SPEC.md](SPEC.md) file.*
 -->

*詳細な情報については、[SPEC.md](SPEC.md) ファイルを参照してください。*

## Contributors & Developers

<!-- 
**“S2J About Window”** is open-source software. The following individuals have contributed to this plugin:
 -->

**"S2J About Window"** はオープンソース・ソフトウェアです。以下の皆様がこのプラグインに貢献しています。

<!-- 
* **Developer**: Koutarou ISHIKAWA
 -->

* **開発者**: Koutarou ISHIKAWA

## Acknowledgments

<!-- 
* Based on [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) by Danger Cove
* Built with SwiftUI and Swift Package Manager
 -->

* Danger Cove 制作 [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) をもとに作成
* SwiftUI および Swift Package Manager で構築
