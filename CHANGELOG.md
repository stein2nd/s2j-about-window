# S2J About Window - CHANGELOG

## unreleased

## 3.0.0 - 2026-11-13

### Added

* [Textual](https://github.com/gonzalezreal/textual) 依存による `MarkdownView` の再実装 (`StructuredText`) — GFM 表・コードブロック・長文 Acknowledgements (onot 形式) に対応
* テストフィクスチャ `FixtureAcknowledgements.md` に onot 生成サンプル (`host-sbom`) を同梱

### Changed

* **Breaking:** 最小 OS を macOS v15.0 / iOS v18.0に引き上げ (`Package.swift`、`project.yml`、公開 API の `@available`)
* `README.md` の `Package.swift` 依存指定を v2.0.14から v3.0.0に更新し、Markdown 節を Textual 前提に更新 (表対応、リモート画像は非推奨)
* `project.yml` に Textual (SPM) を追加、`docs/architecture.md` / `docs/legal_text_spec.md` を同期
* ユニットテスト (`AboutViewTests`、`LegalTextLoaderTests`) を上記実装に合わせて更新

### Fixed

* `AboutViewModel.loadDefaultContent()` で `String(contentsOfFile:encoding: .utf8)` を使用 (macOS v15 / iOS v18で `init(contentsOfFile:)` 非推奨への対応)

### Removed

* `MarkdownView.markdownBlocks(from:)` と `AttributedString(markdown:)` ベースの手動ブロック分割

## 2.0.14 - 2026-11-09

### Changed

* `README.md` の `Package.swift` 依存指定を v2.0.13 から v2.0.14 に更新

### Fixed

* `LegalTextLoaderTests` のテスト用リソースを拡張子付き (`.txt`) に統一し、Xcode / GitHub Actions `test-ios` で拡張子なしファイルがバンドルされず `LegalTextLoader` 関連テストが失敗する問題を修正

## 2.0.13 - 2026-11-09

### Added

* バンドル同梱の License / Acknowledgements を About からシート表示 ([Issue #17](https://github.com/stein2nd/s2j-about-window/issues/17)) — `LegalTextLoader`、`LegalTextView`、`AboutView` フッターボタン、`AboutWindow` / `aboutSheet` / `aboutPopover` のオプション引数
* 仕様書 [`docs/legal_text_spec.md`](docs/legal_text_spec.md) と検討記録 `docs_mod/`
* `LegalTextLoader` 向け Swift Testing (`LegalTextLoaderTests`) とテスト用リソース
* リーガルテキスト用ローカライズキー (en / ja / Base)
* macOS `SampleApp` 用 `SampleResources/LICENSE` と README の組み込み例・`MarkdownView` のサポート範囲の明記

### Changed

* `README.md` の `Package.swift` 依存指定を v2.0.12 から v2.0.13 に更新
* `README.md` API 説明を License 引数・`LegalTextLoader` に合わせて更新
* `docs/architecture.md`、`docs/specs.md`、`docs/SPEC.md` Backlog、`docs/overview.md` (共通仕様リンク) をリーガルテキスト機能に合わせて更新
* `project.yml` に `SampleApp` リソースとユニットテストの `Tests/.../Resources` を追加
* `Package.swift` のテストターゲットにリソース同梱を設定

### Fixed

* Xcode ビルド時に `LegalTextLoaderTests` が `Bundle.module` を参照して失敗する問題を修正 (SPM / Xcode 両対応のバンドル取得)

## 2.0.12 - 2026-11-08

### Changed

* `README.md` の `Package.swift` 依存指定を v2.0.11から v2.0.12に更新

### Fixed

* `MarkdownView` で段落や箇条書きが1行に潰れる問題を修正 (ブロックごとに `Text` を並べて表示)

## 2.0.11 - 2026-11-08

### Added

* `package.json` に Swift 向け npm スクリプトを追加 (`lint:swiftlint`、`lint:swiftformat`、`lint:periphery`、`format:swift`、`profile:swift`、`lint:build`、`analyze:swift`、`lint:swift`)
* Swift リンター／フォーマッター用の設定ファイルを追加 (`.swiftlint.yml`、`.swiftformat`、`.swift-version`、`.periphery.yml`)
* `project.yml` に macOS サンプル・アプリケーション `SampleApp` ターゲットとスキームを追加

### Changed

* `.gitignore` に `build/` を追加し、xcodebuild がリポジトリ直下に作る出力を除外
* GitHub Actions (`docs-lint.yml`) の `actions/setup-node` を v4から v5に更新し、Runner を `ubuntu-24.04` に固定
* `docs/SPEC_CICD.md` の Docs Lint CI 記述を上記に合わせて更新

* 最小 OS を macOS v14.6 / iPadOS v17.6にそろえた (`Package.swift`、`project.yml`、`README.md`)
* `README.md` の `Package.swift` 依存指定を v2.0.10から v2.0.11に更新
* Swift ソースを SwiftFormat で整形し、SwiftLint / Periphery が通るよう調整
* `SampleApp.swift` の macOS サンプルをビルド可能な形に整理
* Xcode 用 `project.yml` のデプロイメントターゲットを SPM・テストターゲットと一致させた (従来 macOS v12.0 / iOS v17.0表記を整理)

### Fixed

* `lint-docs` の Node.js v20非推奨および `ubuntu-latest` 移行予告の Annotation を解消

* `.swiftformat` で `build`、`.build`、`DerivedData` 等を除外し、`lint:swiftformat` が Xcode 生成物を検査して失敗しないようにした
* iOS フレームワーク／ユニットテストターゲットで `CODE_SIGNING_ALLOWED=NO` とし、ローカル Xcode ビルド時の署名・Ad Hoc 関連エラーを回避

## 2.0.10 - 2026-11-06

### Changed

* GitHub Actions (`swift-test.yml`) の `actions/upload-artifact` を v5から v6に更新
* `README.md` の `Package.swift` 依存指定を v2.0.9から v2.0.10に更新
* `docs/SPEC_CICD.md` の CI 記述を上記に合わせて更新

### Fixed

* `test-ios` / `build-release` の Node.js v20非推奨 Annotation (`upload-artifact@v5`) を解消

## 2.0.9 - 2026-11-06

### Changed

* GitHub Actions (`swift-test.yml`、`docs-lint.yml`) の JavaScript アクションを Node.js v24対応版に更新
    * `actions/checkout@v5`
    * `actions/upload-artifact@v5`
    * `codecov/codecov-action@v7` (`file` → `files`)
    * Docs Lint の Node.js を v20から v24に変更
* `README.md` の `Package.swift` 依存指定を v2.0.8から v2.0.9に更新
* `docs/SPEC_CICD.md` の CI 記述を上記に合わせて更新

### Fixed

* GitHub Actions の Node.js v20非推奨 Annotation を解消

## 2.0.8 - 2026-11-06

### Changed

* `@s2j/docs-linter` を ^1.0.26から ^1.0.32に更新
* `README.md` の `Package.swift` 依存指定を v2.0.7から v2.0.8に更新
* `package.json` に `overrides` を追加し、間接依存の `glob` / `minimatch` を修正版に固定

### Fixed

* `npm install` 時に報告されていた moderate severity vulnerabilities (5件) を解消

## 2.0.7 - 2026-10-02

### Changed

* `@s2j/docs-linter` を ^1.0.23から ^1.0.26に更新
* `README.md` の `Package.swift` 依存指定を v2.0.6から v2.0.7に更新
* `.vscode/settings.json` で `json.schemaDownload.enable` を有効化

### Fixed

* 非推奨の `npm.enableScriptExplorer` を削除 (NPM Script Explorer は Explorer の Views から利用できる)

## 2.0.6 - 2026-08-31

### Changed

* `@s2j/docs-linter` を ^1.0.22から ^1.0.23に更新
* `README.md` の `Package.swift` 依存指定を v2.0.3から v2.0.6に更新

## 2.0.5 - 2026-08-10

### Changed

* `@s2j/docs-linter` を ^1.0.21から ^1.0.22に更新
* npm の install scripts 許可として `allowScripts` に `@s2j/docs-linter` を追加 (バージョン非固定)

## 2.0.4 - 2026-07-23

### Changed

* `lint:docs` の対象に `CHANGELOG.md` を追加
* `@s2j/docs-linter` を ^1.0.18から ^1.0.21に更新
* `README.md` の `Package.swift` 依存指定を v2.0.2から v2.0.3に更新

### Fixed

* npm 12+ で `npm install` が Git 依存の取得禁止 (`EALLOWGIT`) により失敗する問題を修正
    * `.npmrc` に `allow-git=all` を追加 (`@s2j/docs-linter` の間接 GitHub 依存に対応)
    * `legacy-peer-deps=true` を追加

## 2.0.3 - 2026-06-11

### Fixed

* GitHub Actions の `test-macos` / `build-release` が Swift v6.2.4で失敗する問題を修正
    * macos-26上の Xcode v26.3は Swift v6.2.4のため、CI ツールチェーンを Xcode v26.5 (Swift v6.3.2+) に統一
    * `test-ios` と同様の Xcode Force-select ステップを `test-macos` / `build-release` に追加
    * ツールチェーン確認で Swift v6.2系を検出した場合に fail するガードを全 job に追加

## 2.0.2 - 2026-06-11

### Changed

* `project.yml` の Project Format を Xcode v26.3相当に更新
    * `xcodeVersion` を v26.5から v26.3に変更
    * `projectFormat: xcode16_3` を追加 (生成される `objectVersion` を90に)
* GitHub Actions (`swift-test.yml`) を Swift v6.3 / Xcode v26.3+ 向けに更新
    * runner を `macos-latest` から `macos-26` に変更
    * 全 job の Xcode バージョンを `26.3` に固定
    * Swift v6.2系 Xcode へのフォールバック (16.4.0等) を削除
    * ツールチェーン確認ステップ (`swift --version`) を追加
* `README.md` のバッジ表示を調整 (Swift バッジの位置変更、iOS 表記を iPadOS に修正)

## 2.0.1 - 2026-06-11

### Changed

* Swift v6.3.x に対応
    * `Package.swift` の `swift-tools-version` を v6.3に更新
    * `project.yml` の `SWIFT_VERSION` を v6.3、`xcodeVersion` を v26.5に更新
* Swift v6の並行性チェックに対応
    * `AboutWindow`、`AboutViewModel`、テストクラスに `@MainActor` を追加
* `README.md` に Xcode、macOS、iOS のバッジを追加
* macOS の最小対応バージョン表記を v14以降に統一

## 2.0.0 - 2026-06-11

### Changed

* ライセンスを GPL-2.0-or-later から GPL-3.0-or-later に更新 (破壊的変更)
    * `LICENSE` を GPL v3全文に差し替え
    * `README.md` のライセンス表記とバッジを GPL v3に更新
* iPadOS の最小対応バージョンを v15から v17に引き上げ (破壊的変更)
