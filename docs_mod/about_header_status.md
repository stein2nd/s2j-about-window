# S2J About Window — About ヘッダーパネル強化 — 検討状況

## 概要 `{@about_header_status:s-h001}`

| 項目 | 内容 |
| --- | --- |
| Issue | [#18 About ヘッダーパネル強化](https://github.com/stein2nd/s2j-about-window/issues/18) |
| 確定仕様 | [about_header_panel_spec.md](../docs/about_header_panel_spec.md) |
| きっかけ | s2j-cozy-brew About UX (iMazing 型レイアウトとの比較) |
| 最終更新 | 2026-11-24 |

## 検討フェーズ `{@about_header_status:s-h002}`

| フェーズ | 内容 | 状態 |
| --- | --- | --- |
| 要件整理 | iMazing 参照と S2J 現状のギャップ表 | **完了** ([§1](../docs/about_header_panel_spec.md)) |
| API | `AboutHeaderOptions` / `AboutHeaderStyle` | **確定** ([§3](../docs/about_header_panel_spec.md)) |
| Issue 起票 | GitHub | **完了** ([#18](https://github.com/stein2nd/s2j-about-window/issues/18)) |
| `docs/` 移行 | `docs/about_header_panel_spec.md` | **完了** |
| 実装 | フェーズ1→3 | **完了** (unreleased) |

## 決定事項 (暫定) `{@about_header_status:s-h003}`

| # | トピック | 決定 |
| --- | --- | --- |
| 1 | **後方互換** | デフォルトは現行 `vertical`。classic は opt-in。 |
| 2 | **Short Description** | Markdown 本文で継続 (ヘッダーに押し込まない)。 |
| 3 | **ビルド番号** | `CFBundleVersion` を括弧付きで版行に併記 (opt-in)。 |
| 4 | **外部リンク** | License / Ack とは別に `primaryLink` 1本 (DigiDNA サイト相当)。 |
| 5 | **実装場所** | `s2j-about-window` 本体。CozyBrew は pin と `CozyBrewAbout` のみ変更。 |
| 6 | **下段ボタン折り返し** | 狭いときは縦積みフォールバック ([§8 #1](../docs/about_header_panel_spec.md))。 |
| 7 | **`primaryLink` 本数** | 初版1本。複数は Markdown に任せる (§8 #2)。 |
| 8 | **iOS ヘッダー** | iPad (横余裕) は classic 可。iPhone 等は縦積み (§8 #3)。 |
| 9 | **macOS ウィンドウサイズ** | host が `defaultSize` 等で調整可能 (§8 #4)。 |

## `docs/` 移行チェックリスト `{@about_header_status:s-docs}`

- [x] Issue 受け入れ条件と [§7](../docs/about_header_panel_spec.md) が一致
- [x] `docs/about_header_panel_spec.md` 採用
- [x] [architecture.md](../docs/architecture.md) 更新
- [x] [specs.md](../docs/specs.md) / [SPEC.md](../docs/SPEC.md) リンク
- [x] CHANGELOG (unreleased)