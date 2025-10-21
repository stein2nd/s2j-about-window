# About This App

This is a sample about window content. You can customize this content by providing your own markdown, JSON, or RTF content when initializing the AboutView.

## Features

- **Cross-platform**: Works on both macOS and iPadOS
- **Customizable**: Support for Markdown, JSON, and RTF content
- **Localized**: Built-in support for multiple languages
- **Modern UI**: Built with SwiftUI for a native look and feel

## Usage

```swift
// macOS
let aboutWindow = AboutWindow()
aboutWindow.showAboutWindow(
    content: "Your markdown content here",
    appName: "Your App",
    version: "1.0.0",
    copyright: "© 2024 Your Company"
)

// iPadOS
AboutView(content: "Your content here")
    .aboutSheet(isPresented: $showAbout, content: "Your content")
```

## License

This library is provided under the MIT License. See the LICENSE file for more details.
