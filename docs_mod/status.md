# S2J About Window - Issue #17 — 検討状況

## 概要

| 項目 | 内容 |
| --- | --- |
| Issue | [#17 License / Acknowledgements 表示用ビュー](https://github.com/stein2nd/s2j-about-window/issues/17) |
| 確定仕様 | [legal_text_spec.md](../docs/legal_text_spec.md) |
| 最終更新 | 2026-11-08 |

## 検討フェーズ

| フェーズ | 内容 | 状態 |
| --- | --- | --- |
| 仕様ドラフト | `docs_mod/` で API・UI・エラー・テストを定義 | **完了** |
| `docs/` 移行 | `docs/legal_text_spec.md` に採用 | **完了** |
| レビュー | 利用側 (s2j-cozy-brew 等)・COMMON_SPEC 整合 | 随時 |
| 実装 | Phase 1 → 2 | **完了** (ローカル `swift test` 済) |

## 決定事項

| # | トピック | 決定 |
| --- | --- | --- |
| 1 | **公開型名** | 表示 `LegalTextView`、状態 `LegalTextContent`、種別 `LegalTextKind`、I/O `LegalTextLoader` (`static` のみの `enum`)。Issue 上の `LicenseView` / ドラフトの `BundledLegalTextView` は採用しない。 |
| 2 | **macOS の提示方法** | macOS / iOS とも **`.sheet` に統一**。補助 `NSWindow` は初版では採用せず **Backlog**。macOS はシートの `minWidth` / `minHeight` で長文向けに広めにする。 |
| 3 | **Acknowledgements の表示** | **文書の役割 + 拡張子** で分岐。License は常にプレーン (等幅 `LegalTextView`)。Acknowledgements は `.md` ならシート内 `MarkdownView`、それ以外はプレーン。`MarkdownView` のサポート範囲外 (mermaid 等) は [README](../README.md) の Markdown 制限と [legal_text_spec.md](../docs/legal_text_spec.md) §6.1 に明記。 |
| 4 | **テスト枠** | 新規テストは **Swift Testing** (`LegalTextLoader` 等)。既存 `AboutViewTests` (XCTest) は変更しない。UI の SnapshotTesting は **Phase 2 以降** で検討。XCTest 全面移行は **別 Issue**。 |

## `docs/` 移行チェックリスト

- [x] 未決事項が解消または「Phase あとで」と明記されている
- [x] 受け入れ条件が Issue #17 と一致 ([legal_text_spec.md](../docs/legal_text_spec.md) §10)
- [x] [architecture.md](../docs/architecture.md) のファイル一覧を更新
- [x] [specs.md](../docs/specs.md) にリンク追加
- [x] [SPEC.md](../docs/SPEC.md) Backlog の該当行を更新
- [x] `overview.md` の COMMON_SPEC リンクを `SPECS.md` に揃える
