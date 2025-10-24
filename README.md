# S2J About Window

<!-- 
A SwiftUI-based About Window library for macOS and iPadOS applications, ported from [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow).
 -->

macOS および iPadOS アプリケーション向けの SwiftUI ベースの About Window ライブラリです。[DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) から移植しました。

## Features

<!-- 
* **Cross-platform**: Works on both macOS (12+) and iPadOS (15+)
* **SwiftUI Native**: Built entirely with SwiftUI for modern UI
* **Customizable Content**: Support for Markdown, JSON, and RTF content
* **Localized**: Built-in support for multiple languages (English, Japanese)
* **Dark Mode**: Full dark mode support
* **Easy Integration**: Simple API for host applications
 -->

* **クロスプラットフォーム**: macOS (v12以降) と iPadOS (v15以降) の両方で動作
* **SwiftUI ネイティブ**: モダン UI を実現する SwiftUI 完全構築
* **カスタマイズ可能なコンテンツ**: Markdown、JSON、RTF コンテンツに対応
* **ローカライズ対応**: 複数言語 (英語、日本語) の組込みサポート
* **ダークモード**: 完全なダークモード対応
* **簡単な統合**: ホスト・アプリケーション向けのシンプルな API

## Requirements

* macOS v12.0+
* iPadOS v15.0+
* Xcode v14.0+
* Swift v5.9+

## Installation

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

## Contributing

<!-- 
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request
 -->

1. リポジトリをフォークする
2. 機能ブランチを作成する
3. 変更を加える
4. 新機能のテストを追加する
5. プルリクエストを送信する

## License

<!-- 
This project is licensed under the GPL 2.0+ License. See the [LICENSE](LICENSE) file for details.
 -->

本プロジェクトは GPL2.0以降ライセンスの下で提供されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## Acknowledgments

<!-- 
* Based on [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) by Danger Cove
* Built with SwiftUI and Swift Package Manager
 -->

* Danger Cove 制作 [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow) をもとに作成
* SwiftUI および Swift Package Manager で構築