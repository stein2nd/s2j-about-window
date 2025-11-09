# S2J About Window

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![React](https://img.shields.io/badge/Swift-5.9-blue?logo=Swift&logoColor=white)](https://www.swift.org)

## Description

<!-- 
S2J About Window is a modern, SwiftUI-based library that provides a customizable About Window for macOS and iPadOS applications. This library was ported from the popular [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) project, bringing its functionality to the SwiftUI ecosystem.

The library offers a flexible and easy-to-use API for displaying application information, credits, and other content in a native About Window. It supports multiple content formats including Markdown, JSON, and RTF, making it easy to create rich, formatted content for your application's About window.
 -->

S2J About Window は、macOS および iPadOS アプリケーション向けのカスタマイズ可能な About ウィンドウを提供する、モダンな SwiftUI ベースのライブラリです。本ライブラリは、人気の [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) プロジェクトから移植され、その機能を SwiftUI エコシステムにもたらしています。

本ライブラリは、ネイティブな About ウィンドウでアプリケーション情報、クレジット、その他のコンテンツを表示するための柔軟で使いやすい API を提供します。Markdown、JSON、RTF など複数のコンテンツ形式をサポートしており、アプリケーションの About ウィンドウ用のリッチなフォーマット済みコンテンツを簡単に作成できます。

## Features

<!-- 
* **Cross-platform**: Works on both macOS (12+) and iPadOS (15+)
* **SwiftUI Native**: Built entirely with SwiftUI for modern UI
* **Customizable Content**: Support for Markdown, JSON, and RTF content
* **Localized**: Built-in support for multiple languages (English, Japanese)
* **Dark Mode**: Full dark mode support
* **Easy Integration**: Simple API for host applications
 -->

* **クロス・プラットフォーム**: macOS (v12以降) と iPadOS (v15以降) の両方で動作
* **SwiftUI ネイティブ**: モダン UI を実現する SwiftUI 完全構築
* **カスタマイズ可能なコンテンツ**: Markdown、JSON、RTF コンテンツに対応
* **ローカライズ対応**: 複数言語 (英語、日本語) の組込みサポート
* **ダークモード**: 完全なダークモード対応
* **簡単な統合**: ホスト・アプリケーション向けのシンプルな API

## License

<!-- 
This project is licensed under the GPL 2.0+ License. See the [LICENSE](LICENSE) file for details.
 -->

本プロジェクトは GPL2.0以降ライセンスの下で提供されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## Support and Contact

<!-- 
For support, feature requests, or bug reports, please visit the [GitHub Issues](https://github.com/stein2nd/s2j-about-window/issues) page.
 -->

サポート、機能リクエスト、またはバグ報告については、[GitHub Issues](https://github.com/stein2nd/s2j-about-window/issues) ページをご覧ください。

---

## Installation

### Requirements

* macOS v12.0+
* iPadOS v15.0+
* Xcode v14.0+
* Swift v5.9+

### Swift Package Manager

<!-- 
Add the following to your `Package.swift` file.
 -->

`Package.swift` ファイルに以下を追加します。

```swift
dependencies: [
    .package(url: "https://github.com/stein2nd/s2j-about-window.git", from: "1.0.0")
]
```

<!-- 
Or add it through Xcode:
 -->

あるいは Xcode から追加します。

<!-- 
1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/stein2nd/s2j-about-window.git`
3. Choose the version and add to your target
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
            
            ## Features
            - Feature 1
            - Feature 2
            - Feature 3
            """,
            appName: "My App",
            version: "1.0.0",
            copyright: "© 2024 My Company"
        )
    }
}
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
            content: "Your about content here",
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
    content: "Your about content here"
)
```

## Content Formats

<!-- 
The library supports multiple content formats:
 -->

ライブラリは、複数のコンテンツ形式をサポートしています。

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

### JSON

```swift
let content = """
{
  "title": "About This App",
  "description": "This is a sample app",
  "features": ["Feature 1", "Feature 2"]
}
"""
```

### RTF

<!-- 
RTF content is automatically parsed and displayed.
 -->

RTF コンテンツは、自動的に解析され表示されます。

## Localization

<!-- 
The library includes built-in localization for:
 -->

ライブラリには、以下の言語のローカライズ機能が組み込まれています。

* English (en)
* Japanese (ja)

<!-- 
You can add your own localizations by providing `Localizable.strings` files in your app bundle.
 -->

アプリバンドルに `Localizable.strings` ファイルを追加することで、独自のローカライズを追加できます。

## Customization

### Default Content

<!-- 
You can provide default content by including an `AboutDefault.md` file in your app bundle:
 -->

アプリバンドルに `AboutDefault.md` ファイルを含めることで、デフォルトコンテンツを提供できます。

```markdown
# About This App

Your default about content here.
```

### Styling

<!-- 
The About Window automatically adapts to your app's appearance, including dark mode support.
 -->

About ウィンドウは、ダークモード対応を含め、アプリケーションの見た目に自動的に適応します。

## API Reference

### AboutWindow (macOS)

```swift
public class AboutWindow {
    public init()
    public func showAboutWindow(content: String, appName: String?, version: String?, copyright: String?)
    public func closeWindow()
}
```

### AboutView (SwiftUI)

```swift
public struct AboutView: View {
    public init(content: String, appName: String?, version: String?, copyright: String?)
}
```

### Extensions

```swift
// iPadOS Sheet
func aboutSheet(isPresented: Binding<Bool>, content: String, appName: String?, version: String?, copyright: String?) -> some View

// iPadOS Popover
func aboutPopover(isPresented: Binding<Bool>, content: String, appName: String?, version: String?, copyright: String?) -> some View
```

## Testing

<!-- 
The library includes comprehensive tests:
 -->

ライブラリには、包括的なテストが含まれています。

```bash
swift test
```

<!-- 
For UI testing with snapshots:
 -->

スナップショットを用いた UI テストの場合。

```bash
swift test --enable-code-coverage
```

## Development

<!-- 
### Project Structure
 -->

### プロジェクト構造

<!-- 
The project follows a standard Swift Package Manager structure:
 -->

このプロジェクトは標準的な Swift Package Manager の構造に従っています:

<!-- 
* `Sources/` - Source code
* `Tests/` - Test files
* `Package.swift` - Package configuration
 -->

* `Sources/` - ソースコード
* `Tests/` - テストファイル
* `Package.swift` - パッケージ設定

<!-- 
### Setting Up Development Environment
 -->

### 開発環境のセットアップ

<!-- 
To set up the development environment for this project:
 -->

このプロジェクトの開発環境をセットアップするには:

<!-- 
1. Clone the repository:

   ```bash
   git clone https://github.com/stein2nd/s2j-about-window.git
   cd s2j-about-window
   ```

2. Open the project in Xcode:

   ```bash
   open Package.swift
   ```

3. Build the project:

   ```bash
   swift build
   ```

4. Run tests:

   ```bash
   swift test
   ```
 -->

1. リポジトリをクローンします:

   ```bash
   git clone https://github.com/stein2nd/s2j-about-window.git
   cd s2j-about-window
   ```

2. Xcode でプロジェクトを開きます:

   ```bash
   open Package.swift
   ```

3. プロジェクトをビルドします:

   ```bash
   swift build
   ```

4. テストを実行します:

   ```bash
   swift test
   ```

<!-- 
### Building and Testing
 -->

### ビルドとテスト

<!-- 
To build the project, use:
 -->

プロジェクトをビルドするには:

```bash
swift build
```
<!-- 
To run tests with code coverage:
 -->

コードカバレッジ付きでテストを実行するには:

```bash
swift test --enable-code-coverage
```


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