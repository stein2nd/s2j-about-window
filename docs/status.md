# S2J About Window - 実装状況

最終更新: 2026-11-16

## 概要 `{@status:s-h001}`

| 項目 | 内容 |
| --- | --- |
| パッケージ | [s2j-about-window](https://github.com/stein2nd/s2j-about-window) (Swift Package) |
| リリース (npm / ドキュメント基準) | **3.0.3** |
| SPM 最小 OS | [overview.md](./overview.md) (Package.swift 準拠) |
| 主依存 (Markdown) | [Textual](https://github.com/gonzalezreal/textual) 0.5.0+ |

本ドキュメントは、**いまの実装・残課題を一覧で把握する入口** です。詳細な箇条書きは持ちません。

## 目的 `{@status:s-h002}`

* カテゴリー別の完了率と、短期 Backlog を **1画面** で確認する。
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

`SPEC.md` §10.4と同期した要約 (2026-11-16時点)。

| カテゴリー | 完了率 | 状態 |
| --- | --- | --- |
| コア機能 (About、Textual、Legal*) | 100% | 運用可能 |
| プラットフォーム (macOS / iPadOS) | 100% | 最小 OS15 / 18 |
| リソース・ローカライズ | 100% | en / ja |
| UI/UX | 100% | ダークモード、アイコン |
| バンドルリーガル表示 | 100% | 2.0.13〜3.0.1、ホスト実証済み |
| CI/CD | 100% | `swift-test.yml`、`docs-lint.yml` |
| コンテンツ形式 (JSON/RTF) | 33% | Markdown のみ |
| テスト・品質保証 | 70% | XCTest + Swift Testing。Snapshot 未 |
| **全体 (概算)** | **約88%** | コアとリーガルは完了 |

## 直近マイルストーン `{@status:s-h006}`

| 時期 | 内容 |
| --- | --- |
| 2.0.13〜2.0.14 | `LegalText*`、About フッター、Issue #17 |
| 3.0.0 | Textual、GFM 表、最小 OS 引き上げ |
| 3.0.1 | Acknowledgements コードブロック折り返し |
| 3.0.2 | 仕様ドキュメント同期、見出しタグ規約 v0.1 |
| 3.0.3 | `docs/status.md`、見出しタグツール、ドキュメント整備 |

## 進行中・短期 Backlog `{@status:s-backlog}`

[SPEC.md](./SPEC.md) §11.1より (優先度高い順)。

| 項目 | 状態 | メモ |
| --- | --- | --- |
| SnapshotTesting / UI テスト | 未 | プレースホルダーのみ |
| Preview Content ディレクトリ | 未 | Xcode Preview 用 |
| JSON / RTF コンテンツ | 未 | Should、Markdown で代替可 |
| 見出しタグ: リンク用 `<a id>` 自動化 | 検討 | 規約 v0.2 ([specs.md](./specs.md) `{@specs:heading-tags-anchors}`) |
| macOS 補助 `NSWindow` で License | Backlog | 初版は `.sheet` 統一 |

## 検証・運用 `{@status:s-h008}`

| 手段 | コマンド / 場所 |
| --- | --- |
| ローカル (macOS + 任意 iOS) | `npm run test:local` / `./scripts/test-local.sh` |
| CI | GitHub Actions `Swift Test`、`Lint Docs` |
| ドキュメント lint | `npm run lint:docs` |
| 見出しタグ付与 | `npm run docs:heading-tags` |

## 関連 `{@status:s-h009}`

* 仕様の入口: [specs.md](./specs.md)
* Issue #17検討記録 (アーカイブ的): [docs_mod/status.md](../docs_mod/status.md)
