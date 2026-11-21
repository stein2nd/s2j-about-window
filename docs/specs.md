# S2J About Window - 仕様書の起点

本ドキュメントは、Swift Package「S2J About Window」の仕様の **入口** です。  
各トピックは、以下のドキュメントに分割しています。AI 伴走やメンテナンス時は、該当する spec を参照してください。

| ドキュメント | 役割 |
| --- | --- |
| [概要](./overview.md) | プロジェクトの存在理由、概要、基本情報 |
| [アーキテクチャー](./architecture.md) | フォルダー構成、主要ファイル、技術スタック、ビルド、責務 |
| [SPEC.md](./SPEC.md) | 要件概要、実装状況サマリ、Backlog、品質評価、Appendix |
| [requirements.md](./requirements.md) | 機能要件・非機能要件 (Must/Should/Could) の詳細 (※将来分離時はここに集約) |
| [api_spec.md](./api_spec.md) | 公開 API の契約 (AboutWindow / AboutView / aboutSheet / aboutPopover) (※将来分離時) |
| [content_spec.md](./content_spec.md) | コンテンツ形式 (Markdown の扱い、フォールバック) (※将来分離時) |
| [localization_spec.md](./localization_spec.md) | ローカライズ (キー一覧、`Bundle.module`、`AboutDefault.md`) (※将来分離時) |
| [platform_spec.md](./platform_spec.md) | プラットフォーム別挙動 (macOS / iPadOS) (※将来分離時) |
| [legal_text_spec.md](./legal_text_spec.md) | バンドル同梱 License / Acknowledgements 表示 ([Issue #17](https://github.com/stein2nd/s2j-about-window/issues/17) 完了・2.0.13〜3.0.1) |
| [SPEC_CICD.md](./SPEC_CICD.md) | CI/CD 仕様 (ワークフロー・ローカルテスト・カバレッジ) |
| [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md) | 仕様の細分化方針とベター・プラクティス |
| [status.md](./status.md) | **実装状況の入口** (カテゴリー別スナップショット・短期 Backlog) |

※ 表中の「※将来分離時」は、現時点では [SPEC.md](./SPEC.md) に内容が含まれており、必要に応じて上記の独立 spec に切り出すことを想定しています。

## 見出しタグ (横断参照) `{@specs:heading-tags}`

**規約バージョン**: v0.1 (S2J シリーズ共通のたたき台。リポジごとに `TARGETS` / `MANUAL_SUFFIXES` を調整)

仕様系 `.md` の ATX 見出し末尾に、リポジトリ内で一意なタグを付けています ([s2j-source-list](https://github.com/stein2nd/s2j-source-list) と同型)。**一意性のスコープはリポジトリ内** とし、他リポジとの衝突は検索時にリポジルートで区切る。

| 項目 | 内容 |
| --- | --- |
| **形式** | 見出し行末の `` `{@<doc>:<suffix>}` `` (例: `` `{@spec:s3-1}` ``) |
| **`<doc>`** | エクステンション子を除いたファイル名の小文字 (例: `SPEC.md` → `spec`、`legal_text_spec.md` → `legal_text_spec`) |
| **`<suffix>`** | 節番号は先頭に `s` を付けてハイフン区切り (`3.1.` → `s3-1`)。番号のない見出しは `s-changed` 等、最終手段は `s-h001` |
| **検索** | リポジトリ全体で `` `{@spec:s3-1}` `` を grep すれば、ファイル・節を特定できる |
| **追加・更新** | 見出しを増やしたあと `npm run docs:heading-tags` (または `python3 scripts/apply-heading-tags.py`) を実行。意味のある手動タグ (`heading-tags` など) は再実行後も保持 |

対象: `docs/*.md` (`status.md` 含む)、`README.md`、`docs_mod/*.md` (テスト用フィクスチャや `AboutDefault.md` は除く)。コードフェンス内の `#` 行には付けない。

**対象外**:

* 各ファイルの **先頭 ATX 見出し** (文書タイトルの H1。ファイル名とほぼ同義のためタグは付けない)
* **`CHANGELOG.md`** 一式 (リリース履歴はバージョン見出しで足り、横断参照の主対象にしない)

### リンク用アンカー `{@specs:heading-tags-anchors}`

`` `{@<doc>:<suffix>}` `` は **検索、AI 指示用** の識別子です。GitHub の GFM が見出しから自動生成する `#見出し` スラッグとは **一致しません** (日本語見出しは特に揺れやすい)。そのため、別ファイルから **クリックで飛ぶリンク** が必要なときは、タグと対応する **リンク用 ID** を使います。

| 項目 | 内容 |
| --- | --- |
| **リンク用 ID** | `<doc>-<suffix>` (`@` や `:` を含めない。例: `` `{@spec:s3-1}` `` → `spec-s3-1`) |
| **Markdown リンク** | `[表示文言](./SPEC.md#spec-s3-1)` (パスは相対でよい) |
| **HTML アンカー (v0.1)** | 見出しの **直前** に手動で置く: `<a id="spec-s3-1"></a>` |
| **見出し行** | 従来どおり `` `{@spec:s3-1}` `` を末尾に付ける (タグと ID は対応表どおり) |

例:

```markdown
<a id="spec-s3-1"></a>

### 3.1. 技術スタック `{@spec:s3-1}`
```

別ファイルから:

```markdown
[技術スタックの節](./SPEC.md#spec-s3-1)
```

**注意**:

* `#` フラグメントには `` `{@spec:s3-1}` `` をそのまま書かない (URL、パーサー上ふさわしくない)。
* 見出し文言だけから作る `[…](./SPEC.md#31-技術スタック…)` に **タグと無関係なスラッグ**を期待しない (環境で変わりうる)。
* v0.1では `<a id="…">` の挿入は **手動** (リンクを張る節だけでよい)。`apply-heading-tags.py` からの自動挿入は v0.2で検討。

**併用の目安**: 日常の横断参照は `` `{@spec:s3-1}` `` + `rg`。README や索引から節にジャンプさせたい箇所だけ、リンク用 ID と `<a id>` を追加する。

## クイック参照 `{@specs:quick-ref}`

* **いま何ができて何が残りか** → [status.md](./status.md) (`` `{@status:s-h005}` `` / 100% チェックリスト `` `{@status:s100}` ``)
* **なぜこのプロジェクトがあるか** → [overview.md](./overview.md)
* **何を Must/Should で作るか** → [SPEC.md](./SPEC.md) §2, §4
* **コードはどこに何を書くか** → [architecture.md](./architecture.md)
* **Xcode Canvas / Preview Content** → [architecture.md](./architecture.md) テスト・プレビュー、[status.md](./status.md#status-devx)
* **macOS / iPadOS で何が違うか** → [SPEC.md](./SPEC.md) §4.1、[architecture.md](./architecture.md)
* **CI やローカルテストの仕様** → [SPEC_CICD.md](./SPEC_CICD.md)
* **仕様をどう分割するかの方針** → [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md)
* **License / Acknowledgements をバンドルから表示** → [legal_text_spec.md](./legal_text_spec.md) (`` `{@legal_text_spec:s1}` `` 付近)
* **仕様見出しのタグの付け方** → 本ファイル `` `{@specs:heading-tags}` `` (リンクは `` `{@specs:heading-tags-anchors}` ``)
