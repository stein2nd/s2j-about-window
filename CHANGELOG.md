# S2J About Window - CHANGELOG

## unreleased

## 2.0.1 - 2026-06-11

### Changed

* Swift v6.3.x に対応
    * `Package.swift` の `swift-tools-version` を 6.3に更新
    * `project.yml` の `SWIFT_VERSION` を 6.3、`xcodeVersion` を 26.5に更新
* Swift 6の並行性チェックに対応
    * `AboutWindow`、`AboutViewModel`、テストクラスに `@MainActor` を追加
* `README.md` に Xcode、macOS、iOS のバッジを追加
* macOS の最小対応バージョン表記を v14以降に統一

## 2.0.0 - 2026-06-11

### Changed

* ライセンスを GPL-2.0-or-later から GPL-3.0-or-later に更新（破壊的変更）
    * `LICENSE` を GPL v3全文に差し替え
    * `README.md` のライセンス表記とバッジを GPL v3に更新
* iPadOS の最小対応バージョンを v15から v17に引き上げ（破壊的変更）
