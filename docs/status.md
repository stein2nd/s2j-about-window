# S2J About Window - 実装状況

最終更新: 2026-11-24

## 概要 `{@status:s-h001}`

| 項目 | 内容 |
| --- | --- |
| パッケージ | [s2j-about-window](https://github.com/stein2nd/s2j-about-window) (Swift Package) |
| リリース (npm / ドキュメント基準) | **3.0.14** |
| SPM 最小 OS | [overview.md](./overview.md) (Package.swift 準拠) |
| 主依存 (Markdown) | [Textual](https://github.com/gonzalezreal/textual) 0.5.0+ |

本ドキュメントは、**いまの実装・残課題を一覧で把握する入口** です。詳細な箇条書きは持ちません。

## 目的 `{@status:s-h002}`

* カテゴリー別の完了率と、短期 Backlog を **1画面** で確認する。
* **100% 完了条件チェックリスト** で Must / Should を `[x]` / `[ ]` として追跡する。
* メンテナンス時に「何が済みで何が残りか」を `SPEC.md` §10に行く前にすばやく見る。

## 非目標 `{@status:s-h003}`

* 機能仕様・ API 契約の正文 (→ [SPEC.md](./SPEC.md)、[README.md](../README.md))。
* リリース履歴の全文 (→ [CHANGELOG.md](../CHANGELOG.md))。
* Issue 単位の検討ログ (→ [docs_mod/status.md](../docs_mod/status.md) など)。

## 責務と正本 `{@status:s-h004}`

| トピック | 正本 |
| --- | --- |
| 要件・使用方法 | [SPEC.md](./SPEC.md) §2、§4、§6 |
| 実装状況の詳細 | [SPEC.md](./SPEC.md) §10 (`{@spec:s10}`) |
| Backlog | [SPEC.md](./SPEC.md) §11 (`{@spec:s11}`) |
| バンドル License / Acknowledgements | [legal_text_spec.md](./legal_text_spec.md) (Issue [#17](https://github.com/stein2nd/s2j-about-window/issues/17) 完了) |
| About ヘッダーパネル (classic / build / primary link) | [about_header_panel_spec.md](./about_header_panel_spec.md) (Issue [#18](https://github.com/stein2nd/s2j-about-window/issues/18) 完了・3.0.11、[**Cozy Brew**](https://github.com/stein2nd/s2j-cozy-brew) ホスト実証済み) |
| CI / ローカルテスト | [SPEC_CICD.md](./SPEC_CICD.md) |
| コード構成 | [architecture.md](./architecture.md) |

## スナップショット (カテゴリー別) `{@status:s-h005}`

`SPEC.md` §10.4と同期した要約 (2026-11-21時点)。

| カテゴリー | 完了率 | 状態 |
| --- | --- | --- |
| コア機能 (About、Textual、Legal*) | 100% | 運用可能 |
| プラットフォーム (macOS / iPadOS) | 100% | 最小 OS15 / 18 |
| リソース・ローカライズ | 100% | en / ja |
| UI/UX | 100% | ダークモード、アイコン |
| バンドルリーガル表示 | 100% | 2.0.13〜3.0.1、ホスト実証済み |
| CI/CD | 100% | `swift-test.yml`、`docs-lint.yml` |
| 開発体験 (Xcode Preview) | 100% | `Preview Content/`、`PreviewContent.swift` |
| コンテンツ形式 (JSON/RTF) | 100% | Markdown + JSON 整形 / RTF 表示 (`AboutContentView`) |
| テスト・品質保証 | 85% | XCTest + Snapshot + Swift Testing (iOS: ViewInspector) |
| About ヘッダーパネル (Issue #18) | 100% | `AboutHeaderOptions` / classic / build / `primaryLink`、Cozy Brew 実証済み |
| **全体 (概算)** | **約96%** | Issue `#18` 実装・ホスト受け入れ完了 |

**完了条件列:** 100% 到達用チェックリスト。`[x]` = 満たし済み、`[ ]` = 未。各§のアンカーが正本。実装％は当該§の `[x]` 数 ÷ 全項目数 (仕様行・[§ゲート外](#status-gates)を除く)。

## 機能一覧 `{@status:s-h006}`

| 機能名 | 実装済み/未実装 | 実装％ | 完了条件 (100%) |
| --- | --- | --- | --- |
| 仕様 (`docs/`) | 確定 | 100 | [§仕様・ドキュメント](#status-spec-docs) (5/5) |
| コア About (Must) | 実装済み | 100 | [§コア](#status-core) (8/8) |
| バンドル License / Acknowledgements | 実装済み | 100 | [§リーガル](#status-legal) (5/5) |
| プラットフォーム・ローカライズ | 実装済み | 100 | [§プラットフォーム](#status-platform) (4/4) |
| CI ・ユニットテスト | 実装済み | 100 | [§CI・単体](#status-quality-unit) (6/6) |
| Snapshot / UI テスト | 実装済み | 100 | [§Snapshot と UI](#status-quality-ui) (2/2) |
| コンテンツ形式 (Should) | 実装済み | 100 | [§Should コンテンツ](#status-should-content) (4/4) |
| 開発体験 (Preview 等) | 実装済み | 100 | [§開発体験](#status-devx) (1/1) |
| About ヘッダーパネル (Issue #18) | 実装済み | 100 | [§About ヘッダー](#status-about-header) (11/11) |

**Must 範囲 (上表の先頭5行):** **100%** — SPM ライブラリとしてホストに組込み可能な水準。

**全体 (Should、Snapshot、Issue `#18` 含む):** チェックリスト **46項目中46項目** = **100%** (下表)。

## 100% 完了条件チェックリスト `{@status:s100}`

[S2J Acknowledgements](https://github.com/stein2nd/s2j-acknowledgements/blob/main/docs/status.md) 同型。検証は `npm run test:local` / CI を正本とする ([SPEC_CICD.md](./SPEC_CICD.md))。

### 仕様・ドキュメント `{@status:s-h008}`

* [x] [specs.md](./specs.md) 索引とクイック参照
* [x] [SPEC.md](./SPEC.md) / [architecture.md](./architecture.md) / [legal_text_spec.md](./legal_text_spec.md) が v3.0.x 実装と同期
* [x] [docs/status.md](./status.md) による実装状況の入口
* [x] GitHub Actions `Lint Docs` (`docs-lint.yml`)
* [x] 見出しタグ規約 v0.1と `npm run docs:heading-tags`

### コア About (Must) `{@status:s-about-must}`

正本: [SPEC.md](./SPEC.md) §2・§4

* [x] macOS `AboutWindow` (`NSWindow` + 公開 API)
* [x] 共通 `AboutView` / `AboutViewModel` (メタデータ・ `AboutContentView` 本文・ `contentType`)
* [x] `MarkdownView` (Textual `StructuredText`、About `.default`)
* [x] iPadOS `aboutSheet` / `aboutPopover` ([architecture.md](./architecture.md))
* [x] リソース `AboutDefault.md` と `Bundle.module` 読み込み
* [x] ダークモード・アプリアイコン (プラットフォーム別)
* [x] `Package.swift` — Textual 依存、最小 OS ([overview.md](./overview.md))
* [x] 公開 API、使用例 ([README.md](../README.md) §6)

### バンドル License / Acknowledgements `{@status:s-license-acknowledgements}`

正本: [legal_text_spec.md](./legal_text_spec.md)、Issue [#17](https://github.com/stein2nd/s2j-about-window/issues/17)

* [x] `LegalTextLoader` / `LegalTextLoadResult`
* [x] `LegalTextView` と About フッター連携
* [x] リーガル Markdown — Textual `.gitHub` + `overflowMode(.wrap)` (v3.0.1)
* [x] `LegalTextLoaderTests` (Swift Testing)
* [x] ホスト実証 (例: Cozy Brew — Acknowledgements 表・長文表示)

### プラットフォーム・ローカライズ `{@status:s-h011}`

* [x] 最小 OS ([overview.md](./overview.md))、`@available`、CI シミュレーター
* [x] `en` / `ja` / `Base` の `Localizable.strings`
* [x] `#if os` 方針どおり macOS / iOS の責務分離 ([architecture.md](./architecture.md))
* [x] `SampleApp` (macOS) と XcodeGen `project.yml`

### CI、ユニットテスト `{@status:s-ci}`

正本: [SPEC_CICD.md](./SPEC_CICD.md)

* [x] Workflow `Swift Test` (macOS + iOS 直列)
* [x] `./scripts/test-local.sh` / `npm run test:local`
* [x] `AboutViewTests` (XCTest)
* [x] `LegalTextLoaderTests` + フィクスチャ `FixtureAcknowledgements.md`
* [x] `npm run lint:docs` が `docs/**/*.md` を対象
* [x] `npm run lint:swift` (SwiftLint / SwiftFormat / Periphery)

### Snapshot と UI テスト {#status-quality-ui} `{@status:s-snapshot-ui-status-quality-ui}`

正本: [SPEC.md](./SPEC.md) §11.0、`Package.swift` / `project.yml` (テスト依存のみ)

* [x] SnapshotTesting 統合と About 画面のスナップショット (`AboutViewSnapshotTests`、`__Snapshots__/AboutViewSnapshotTests/*.png` 2件、macOS は `NSHostingView`。参照記録: `update-snapshots` / macos-26、比較: `test-macos`。ローカル `swift test` は `XCTSkip`)
* [x] iPadOS `.sheet` の UI 検証 (`AboutSheetInspectorTests` + ViewInspector — `aboutSheet` は View 直下 `.sheet`、`inspect().color().sheet()`。`test-ios` / `project.yml` の `S2JAboutWindowTests-iOS`。ローカル macOS `swift test` では未実行)

### Should コンテンツ形式 {#status-should-content} `{@status:s-should-status-should-content}`

正本: [SPEC.md](./SPEC.md) §2.1.3 (Should)、[architecture.md](./architecture.md) (`AboutContentView`)

* [x] Markdown コンテンツ表示 (Textual `MarkdownView`)
* [x] JSON オブジェクト形式のパース・表示 (`AboutContentFormat` — 整形 JSON、`.automatic` で無効時は Markdown にフォールバック)
* [x] RTF ドキュメント形式の表示 (`NSAttributedString` / `AttributedString`、本文は `AboutContentView`)
* [x] 明示的 `AboutContentType` (`automatic` / `markdown` / `json` / `rtf`) — `AboutView` / `AboutWindow` / `aboutSheet` / `aboutPopover`

### 開発体験 {#status-devx} `{@status:s-status-devx}`

* [x] Xcode Preview 用 `Preview Content` ディレクトリ (`AboutPreview.md` / `MarkdownPreview.md`、`PreviewContent.swift`、`project.yml` の `DEVELOPMENT_ASSET_PATHS`)

### About ヘッダーパネル (Issue #18) {#status-about-header} `{@status:s-about-issue-status-about-header}`

正本: [about_header_panel_spec.md](./about_header_panel_spec.md)、Issue [#18](https://github.com/stein2nd/s2j-about-window/issues/18)

* [x] 仕様確定 (`docs/about_header_panel_spec.md` 正本、`docs_mod/about_header_status.md` 移行済み)
* [x] `AboutHeaderOptions` / `AboutHeaderStyle` と `AboutView` / `AboutWindow` / `aboutSheet` / `aboutPopover` への `headerOptions` 配線 (デフォルトは現行 `vertical` 互換、AHP-01 / AHP-08)
* [x] ビルド番号表示 (`showBuildNumber`、`CFBundleVersion`、任意上書き) — フェーズ1
* [x] `classicHorizontal` レイアウトと `iconSideLength` (vertical: 64 / classic: 128) — フェーズ2
* [x] `primaryLink`、accessory 画像、`supportIdentifier` — フェーズ3 (AHP-05〜07)
* [x] 下段 License / Ack / `primaryLink` の狭幅 **縦積み** フォールバック (§8 #1)
* [x] iOS: iPad で横余裕時は classic 可、iPhone 等は `.vertical` (§8 #3)
* [x] macOS: host が `AboutWindow` / `showAboutWindow` の初期サイズ等を調整可能 (§8 #4)
* [x] アクセシビリティ: メタ行の VoiceOver 読み上げ、各コントロールのラベル (AHP-09、AHP-NF-02)
* [x] テスト・受け入れ: 既存テスト、Snapshot が `headerOptions: .default` で緑、classic/build の Snapshot が1件以上、build 文字列ユニット (`AboutHeaderOptionsTests`)
* [x] ホスト受け入れ: [s2j-cozy-brew](https://github.com/stein2nd/s2j-cozy-brew) で About 表示確認 (3.0.11+、2026-11-24)

**Issue [#18](https://github.com/stein2nd/s2j-about-window/issues/18):** Close 済み (ライブラリ実装 v3.0.11、ホスト実証上記)。

## ゲート外・任意 `{@status:s-h017}`

**100% 分母外** (未完了でも `Must` 100% は維持)。

| # | 内容 | 備考 |
| --- | --- | --- |
| G1 | macOS 専用 `NSWindow` で License 表示 | [legal_text_spec.md](./legal_text_spec.md) Backlog。初版は `.sheet` 統一 |
| G2 | 見出しタグ `<a id>` の自動挿入 (v0.2) | [specs.md](./specs.md) `{@specs:heading-tags-anchors}` |
| G3 | カスタムテーマ・アニメーション・外部翻訳 API | [SPEC.md](./SPEC.md) §11.3 |

**補足:** スナップショット表の **約96%** は [SPEC.md](./SPEC.md) §10.4のカテゴリー要約に Issue `#18` を反映。本チェックリストは上記 `[x]` 比率で **100%**。

## 直近マイルストーン `{@status:s-h018}`

| 時期 | 内容 |
| --- | --- |
| 2.0.13〜2.0.14 | `LegalText*`、About フッター、Issue #17 |
| 3.0.0 | Textual、GFM 表、最小 OS 引き上げ |
| 3.0.1 | Acknowledgements コードブロック折り返し |
| 3.0.2 | 仕様ドキュメント同期、見出しタグ規約 v0.1 |
| 3.0.3 | `docs/status.md`、見出しタグツール、ドキュメント整備 |
| 3.0.4 | 100% 完了条件チェックリスト、`@s2j/docs-linter` 1.0.34 |
| 3.0.5 | `Preview Content/`、Canvas プレビュー、開発体験チェックリスト100% |
| 3.0.6 | Snapshot / ViewInspector 初版、`Package.swift` テスト依存、仕様同期 |
| 3.0.7 | `macos-26` スナップショット CI 修正、`project.yml` に ViewInspector / SnapshotTesting、`test-ios` 修復、`aboutSheet` の View 直下 `.sheet` 化 (ViewInspector) |
| 3.0.9 | `aboutSheetNavigationChrome` 整理、ローカル `npm run lint:swift` (SwiftLint / SwiftFormat) 通過 |
| 3.0.10 | Should コンテンツ JSON/RTF、`AboutContentType` / `contentType` API、`AboutContentFormatTests` |
| 3.0.11 | Issue #18 `AboutHeaderOptions` / classic ヘッダー、ビルド番号、`primaryLink` |

## 進行中・短期 Backlog `{@status:s-backlog}`

[SPEC.md](./SPEC.md) §11.1より (優先度高い順)。

| 項目 | 状態 | メモ |
| --- | --- | --- |
| SnapshotTesting / UI テスト | 済 | `AboutViewSnapshotTests` / `AboutSheetInspectorTests` |
| JSON / RTF コンテンツ | 済 | v3.0.10 `AboutContentView` / `AboutContentType` |
| About ヘッダーパネル (classic / build / primary link) | 済 | Issue `#18` Close — Cozy Brew ホスト実証 |
| 見出しタグ: リンク用 `<a id>` 自動化 | 検討 | 規約 v0.2 ([specs.md](./specs.md) `{@specs:heading-tags-anchors}`) |
| macOS 補助 `NSWindow` で License | Backlog | 初版は `.sheet` 統一 |

## 検証・運用 `{@status:s-h020}`

| 手段 | コマンド / 場所 |
| --- | --- |
| ローカル (macOS + 任意 iOS) | `npm run test:local` / `./scripts/test-local.sh` |
| CI | GitHub Actions `Swift Test`、`Lint Docs` |
| ドキュメント lint | `npm run lint:docs` |
| 見出しタグ付与 | `npm run docs:heading-tags` |

## 関連 `{@status:s-h021}`

* 仕様の入口: [specs.md](./specs.md)
* Issue `#17` 検討記録 (アーカイブ的): [docs_mod/status.md](../docs_mod/status.md)
* Issue `#18` 検討記録: [docs_mod/about_header_status.md](../docs_mod/about_header_status.md)
