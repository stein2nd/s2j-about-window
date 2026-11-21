# S2J About Window - 実装状況

最終更新: 2026-11-21

## 概要 `{@status:s-h001}`

| 項目 | 内容 |
| --- | --- |
| パッケージ | [s2j-about-window](https://github.com/stein2nd/s2j-about-window) (Swift Package) |
| リリース (npm / ドキュメント基準) | **3.0.5** |
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
| コンテンツ形式 (JSON/RTF) | 33% | Markdown のみ |
| テスト・品質保証 | 70% | XCTest + Swift Testing。Snapshot 未 |
| **全体 (概算)** | **約88%** | コアとリーガルは完了 |

**完了条件列:** 100% 到達用チェックリスト。`[x]` = 満たし済み、`[ ]` = 未。各§のアンカーが正本。実装％は当該§の `[x]` 数 ÷ 全項目数 (仕様行・[§ゲート外](#status-gates)を除く)。

## 機能一覧 `{@status:s-h006}`

| 機能名 | 実装済み/未実装 | 実装％ | 完了条件 (100%) |
| --- | --- | --- | --- |
| 仕様 (`docs/`) | 確定 | 100 | [§仕様・ドキュメント](#status-spec-docs) (5/5) |
| コア About (Must) | 実装済み | 100 | [§コア](#status-core) (8/8) |
| バンドル License / Acknowledgements | 実装済み | 100 | [§リーガル](#status-legal) (5/5) |
| プラットフォーム・ローカライズ | 実装済み | 100 | [§プラットフォーム](#status-platform) (4/4) |
| CI ・ユニットテスト | 実装済み | 100 | [§CI・単体](#status-quality-unit) (6/6) |
| Snapshot / UI テスト | 未 | 0 | [§Snapshot と UI](#status-quality-ui) (0/2) |
| コンテンツ形式 (Should) | 部分 | 33 | [§Should コンテンツ](#status-should-content) (1/3) |
| 開発体験 (Preview 等) | 実装済み | 100 | [§開発体験](#status-devx) (1/1) |

**Must 範囲 (上表の先頭5行):** **100%** — SPM ライブラリとしてホストに組込み可能な水準。

**全体 (Should と Snapshot 含む):** チェックリスト **34項目中30項目** ≒ **約88%** (下表と [SPEC.md](./SPEC.md) §11に対応)。

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
* [x] 共通 `AboutView` / `AboutViewModel` (メタデータ・ Markdown 本文)
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

* [x] 最小 OS ([overview.md](./overview.md))、`@available`、CI シミュレータ
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

### Snapshot と UI テスト `{@status:s-snapshot-ui}`

正本: [SPEC.md](./SPEC.md) §11.1

* [ ] SnapshotTesting 統合と About 画面のスナップショット
* [ ] iPadOS `.sheet` の UI 検証 (ViewInspector 等)

### Should コンテンツ形式 `{@status:s-should}`

正本: [SPEC.md](./SPEC.md) §2 (Should)、§11.2

* [x] Markdown コンテンツ表示 (Textual)
* [ ] JSON オブジェクト形式のパース・表示
* [ ] RTF ドキュメント形式の表示

### 開発体験 {#status-devx} `{@status:s-h015}`

* [x] Xcode Preview 用 `Preview Content` ディレクトリ (`AboutPreview.md` / `MarkdownPreview.md`、`PreviewContent.swift`、`project.yml` の `DEVELOPMENT_ASSET_PATHS`)

## ゲート外・任意 `{@status:s-h016}`

**100% 分母外** (未完了でも `Must` 100% は維持)。

| # | 内容 | 備考 |
| --- | --- | --- |
| G1 | macOS 専用 `NSWindow` で License 表示 | [legal_text_spec.md](./legal_text_spec.md) Backlog。初版は `.sheet` 統一 |
| G2 | 見出しタグ `<a id>` の自動挿入 (v0.2) | [specs.md](./specs.md) `{@specs:heading-tags-anchors}` |
| G3 | カスタムテーマ・アニメーション・外部翻訳 API | [SPEC.md](./SPEC.md) §11.3 |

**補足:** スナップショット表の **約88%** は [SPEC.md](./SPEC.md) §10.4のカテゴリー加重。本チェックリストの **約88%** は上記§の機械的な `[x]` 比率。

## 直近マイルストーン `{@status:s-h017}`

| 時期 | 内容 |
| --- | --- |
| 2.0.13〜2.0.14 | `LegalText*`、About フッター、Issue #17 |
| 3.0.0 | Textual、GFM 表、最小 OS 引き上げ |
| 3.0.1 | Acknowledgements コードブロック折り返し |
| 3.0.2 | 仕様ドキュメント同期、見出しタグ規約 v0.1 |
| 3.0.3 | `docs/status.md`、見出しタグツール、ドキュメント整備 |
| 3.0.4 | 100% 完了条件チェックリスト、`@s2j/docs-linter` 1.0.34 |
| 3.0.5 | `Preview Content/`、Canvas プレビュー、開発体験チェックリスト100% |

## 進行中・短期 Backlog `{@status:s-backlog}`

[SPEC.md](./SPEC.md) §11.1より (優先度高い順)。

| 項目 | 状態 | メモ |
| --- | --- | --- |
| SnapshotTesting / UI テスト | 未 | プレースホルダーのみ |
| JSON / RTF コンテンツ | 未 | Should、Markdown で代替可 |
| 見出しタグ: リンク用 `<a id>` 自動化 | 検討 | 規約 v0.2 ([specs.md](./specs.md) `{@specs:heading-tags-anchors}`) |
| macOS 補助 `NSWindow` で License | Backlog | 初版は `.sheet` 統一 |

## 検証・運用 `{@status:s-h019}`

| 手段 | コマンド / 場所 |
| --- | --- |
| ローカル (macOS + 任意 iOS) | `npm run test:local` / `./scripts/test-local.sh` |
| CI | GitHub Actions `Swift Test`、`Lint Docs` |
| ドキュメント lint | `npm run lint:docs` |
| 見出しタグ付与 | `npm run docs:heading-tags` |

## 関連 `{@status:s-h020}`

* 仕様の入口: [specs.md](./specs.md)
* Issue #17検討記録 (アーカイブ的): [docs_mod/status.md](../docs_mod/status.md)
