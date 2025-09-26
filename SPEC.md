# SPEC.md (DCOAboutWindow - SwiftUI Port)

## プロジェクト概要

* 元リポジトリ: [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow)
* 目的: AppKit ベースの「About Window」を SwiftUI で再実装する
* 対応OS: macOS 12 以上

## 技術スタック

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/COMMON_SPEC.md) に準拠します。

## 開発ルール

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/COMMON_SPEC.md) に準拠します。

## 国際化・ローカライズ

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/COMMON_SPEC.md) に準拠します。

## コーディング規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/COMMON_SPEC.md) に準拠します。

## デザイン規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/COMMON_SPEC.md) に準拠します。

## テスト方針

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/COMMON_SPEC.md) に準拠します。

## 個別要件

* 元リポジトリ既存の Objective-C / AppKit 実装は参考とし、直接利用しません。
* UI は SwiftUI の `WindowGroup` / `Sheet` を利用します。
* 情報表示内容: アプリ名 / バージョン / 著作権 / ライセンス情報
* ダークモード対応は、必須です。

### プロジェクト構成

```
`s2j-about-window`/
├── `SPEC.md`
├── `s2j-about-windowApp.swift`
├── `ContentView.swift`
├── `Localizable.strings` (Base, ja, en, …)
├── `Assets.xcassets`
├── Tests/
├── UITests/
└── Preview Content/
```

### 国際化・ローカライズ

* ローカライズ対応は、必須 (英語・日本語) の為、Base, English, Japanese を初期追加します。

### デザイン規約

* アイコンは App アイコンから自動取得します。

### テスト方針

* テスト: ライセンス表示部分は SnapshotTesting を実施します。

## Appendix A: Xcode プロジェクト作成ウィザード推奨選択肢リスト

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/COMMON_SPEC.md) に準拠します。

### 1. テンプレート選択

* **Platform**: macOS
* **Template**: App

### 2. プロジェクト設定

| 項目 | 推奨値 | 理由 |
|------|--------|------|
| Product Name | `s2j-about-window` | `SPEC.md` のプロダクト名と一致 |
| Team | Apple ID に応じて設定 | コード署名のため |
| Organization Identifier | `com.s2j` | ドメイン逆引き規則、一貫性確保 |
| Interface | SwiftUI | SwiftUI ベースを前提 |
| Language | Swift (Swift 7.0) | Xcode 26.0.1 に同梱される Swift バージョン (Objective-C は不要) |
| Use Core Data | Off | データ永続化不要 |
| Include Tests | On | `SPEC.md` に基づきテストを考慮 |
| Include CloudKit | Off | 不要 |
| Include Document Group | Off | Document-based App ではない |
| Source Control | On (Git) | `SPEC.md` / GitHub 運用をリンクさせるため |

## Backlog

* ライセンスビューで Markdown をサポートする。
* Swift Package として切り出し可能な構造にする。
* UI ローカライズについて、外部翻訳サービス (例: DeepL API) との連携を検討する。
