# Swift アプリケーションにおける仕様書の細分化 — ベター・プラクティス

## 1. はじめに `{@spec_structure:s1}`

本ドキュメントでは、[lead-validation-assist](https://github.com/stein2nd/lead-validation-assist) で採用した「仕様の細分化」を、Swift アプリケーション (および S2J About Window) にどう適用するかを整理します。  
目的は **AI 伴走開発** と **後日のメンテナンス** の両方を考慮した、ほどよい粒度の仕様構成です。

---

## 2. なぜ細分化するか (Python と共通の考え方) `{@spec_structure:s2}`

* **検索性**:
    * 変更したいトピック (例: スコア式、住所正規化、API 契約) が1ファイルに集約され、AI も人間も、「どこを読むか」が明確になる。
* **責務の分離**:
    * 「なぜこのプロジェクトがあるか」「何を入力/出力とするか」「コードはどこに書くか」を別ファイルに分けると、仕様の更新が衝突しにくい。
* **テスト・検証との対応**:
    * 数式・ルール・データ定義が独立したドキュメントになっていると、実装やテストを「その仕様に合わせる」形で書きやすい。
* **AI のコンテキスト効率**:
    * 大きな SPEC を毎回渡すより、必要な spec だけを指定して渡すほうがトークン効率も良く、タスクに直結した指示を出しやすい。

Python の lead-validation-assist では、たとえば次のように分けています。

| ファイル | 役割 |
| --- | --- |
| `specs.md` | 仕様の起点 (目次・参照先) |
| `overview.md` | プロジェクトの存在理由の明文化 |
| `scoring_spec.md` | スコア算出ロジックの数式化 |
| `kenall_import_spec.md` | 郵便データ取込と特殊行除外の定義 |
| `data_dictionary.md` | 出力 CSV の列定義の明文化 |
| `architecture.md` | コード構造と責務の明文化 |
| `address_normalization_spec.md` | 住所正規化ルールの厳密定義 |

Swift アプリケーションでも、「何を明文化するか」はドメインに合わせて変えつつ、**同じ考え方**で細分化できます。

---

## 3. Swift アプリケーション向けの細分化の目安 `{@spec_structure:s3}`

「Python スクリプトだから」というより、次の観点で分けると扱いやすいです。

### 3.1. 分離するとよいもの `{@spec_structure:s3-1}`

| 観点 | 内容 | 分離の利点 |
| --- | --- | --- |
| **存在理由・スコープ** | プロジェクトの目的、対象ユーザー、共通 SPEC への参照 | 方針変更時に overview だけ更新すればよい |
| **公開 API の契約** | 型・引数・戻り値・挙動の要約 | ライブラリの場合、利用者と AI の両方が「契約」を一ヵ所で参照できる |
| **ドメインルール** | 数式・ビジネスルール・フォーマット仕様 (例: Markdown の扱い、フォールバック) | 実装・テストが「その spec に従っているか」で検証しやすい |
| **コード構造と責務** | モジュール/ファイル/クラスごとの責務、MVVM 等の方針 | 新機能を「どこに書くか」の判断が AI ・人間ともにしやすい |
| **プラットフォーム別挙動** | macOS / iPadOS で何が違うか、`#if os` の意図 | プラットフォーム固有の変更が1ファイルにまとまる |
| **データ・リソース定義** | ローカライズキー一覧、リソースの置き場所・上書き可能性 | 翻訳・リソース追加時に参照する単一の情報源になる |
| **CI/CD** | すでに `SPEC_CICD.md` のように分離済みならそのまま | ビルド・テスト・デプロイの話題がメイン SPEC から分離される |

### 3.2. 無理に分けなくてよいもの `{@spec_structure:s3-2}`

* **実装状況サマリ、Backlog**:
    * 更新頻度が高く、他の仕様と密に連動するため、`SPEC.md` 内のセクションや `implementation_status.md` 1本にまとめておいてもよい。
* **ごく小さいプロジェクト**:
    * ファイル数が少なく、仕様も1本で十分回る場合は、`specs.md` で「起点」だけ用意し、詳細は `SPEC.md` に残す形でもよい。

### 3.3. AI 伴走・ンテナンスの観点でのポイント `{@spec_structure:s3-3}`

* **仕様の起点を1つにする**:
    * `docs/specs.md` で「どの spec が何を担当するか」を一覧にし、AI や新規参加者に「まずここを見る」と案内できるようにする。
* **1ファイル、1テーマ**:
    * 関心 (「API の契約」「Markdown の扱い」「コード構造」) ごとに、このように1ファイルにまとめると、プロンプトで「`api_spec.md` を参照して実装して」のように指示しやすい。
* **数式・ルールはあいまいさを減らす**:
    * 可能な範囲で「〜とする」「〜のときは X とする」と明文化すると、AI の解釈ブレが減り、テストで仕様と実装の対応が取りやすい。
* **共通仕様は参照で済ませる**:
    * 既存の COMMON_SPEC 等は「準拠する」とだけ書き、本文は別リポジトリに任せる。重複を避けつつ、プロジェクト固有の部分だけを spec に書く。

---

## 4. S2J About Window への適用 — 本リポジトリの構成 `{@spec_structure:s4}`

`docs/SPEC.md` には要件、設計、実装状況、Backlog がまだ多く含まれますが、**入口、概要、構造、ドメイン別仕様、CI/CD** はすでに別ファイルに分かれています。  
以下は **`docs/` に実在する** Markdown のみを列挙した構成です (索引は [specs.md](./specs.md))。

### 4.1. 推奨ファイル構成 (実在ファイル) `{@spec_structure:s4-1}`

| ファイル | 役割 | 主な参照先 (他ファイル、README) |
| --- | --- | --- |
| **docs/specs.md** | 仕様の起点。下表へのリンクとクイック参照。 | 全 spec |
| **docs/overview.md** | 存在理由、スコープ、最小 OS、共通 SPEC への参照。 | 外部 COMMON_SPEC |
| **docs/architecture.md** | MVVM、ディレクトリ構成、ファイル責務、`#if os` 方針、テスト配置。 | `legal_text_spec.md` |
| **docs/legal_text_spec.md** | バンドル License / Acknowledgements (API、UI、Textual との境界)。 | `architecture.md`、`README.md` Markdown 節 |
| **docs/SPEC_CICD.md** | GitHub Actions、ローカル `test-local.sh`、カバレッジ、Docs Lint。 | `.github/workflows/`、`package.json` |
| **docs/SPEC.md** | 要件 (Must/Should)、個別要件、使用方法、実装状況サマリ、Backlog、品質評価、Appendix。 | §2・§4に API、ローカライズ、プラットフォーム差の記述が残る |
| **docs/SPEC_STRUCTURE.md** | 仕様細分化の方針 (本ドキュメント)。 | — |
| **docs/status.md** | 実装状況の入口 (スナップショット・短期 Backlog)。 | `SPEC.md` §10・§11 |

補足:

* **公開 API の詳細**は現状 [README.md](../README.md) と `SPEC.md` §6が主な情報源です。
* **将来** `requirements.md` などに切り出す場合は、[specs.md](./specs.md) の「将来分離時」行の想定どおり、`SPEC.md` から段落を移し索引を更新します (本節の表には、未作成ファイルは含めません)。

### 4.2. この構成の効果 `{@spec_structure:s4-2}`

* **AI 伴走**:
    * 「コードをどこに書くか」→ `architecture.md`、「リーガルテキスト」→ `legal_text_spec.md`、「CI を直す」→ `SPEC_CICD.md`、「Must/Should や完了率」→ `SPEC.md` §10など、タスクに応じた spec を指定しやすい。
* **メンテナンス**:
    * Textual / `LegalText*` の変更は `architecture.md` と `legal_text_spec.md` をそろえて更新。ワークフロー変更は `SPEC_CICD.md` のみ、など責務が分かれる。
* **オンボーディング**:
    * [specs.md](./specs.md) の一覧とクイック参照から、実在ファイルだけをたどれる。

### 4.3. ドキュメントを更新するときの進め方 `{@spec_structure:s4-3}`

1. **索引を先に確認** — 新規トピックやファイルを増やしたら [specs.md](./specs.md) の表とクイック参照を更新する。
2. **トピック別に1ファイル** — 変更が `legal_text_spec.md` の領域ならそこに書く。横断的な実装状況、Backlog は `SPEC.md` §10・§11に集約する。
3. **`SPEC.md` との重複を減らす** — `overview.md` / `architecture.md` に移した内容は、`SPEC.md` 側を短くし「詳細は ○○.md を参照」に寄せる (未作成の独立 spec を前提にしない)。
4. **実装リリース後** — `SPEC.md` の実装状況・`CHANGELOG.md`・必要なら `README.md` の SPM バージョンを同期する。
5. **さらに細分化する場合** — 新しい `docs/*.md` を追加し、その上で `specs.md` と本節 §4.1の表を更新する (計画だけのファイル名を表に書かない)。

---

## 5. まとめ `{@spec_structure:s5}`

* Swift アプリケーションでも、**「存在理由」「API 契約」「ドメインルール」「コード構造」「プラットフォーム差」「リソース定義」** などは、それぞれ1ファイルにまとめておくと、AI 伴走とメンテナンスの両方に有利です。
* **仕様の起点 (specs.md) を1つ用意** し、そこから各 spec にリンクする構成にすると、参照が安定します。
* S2J About Window では、`` `{@spec_structure:s4-1}` `` (§4.1) のとおり、実在する `specs.md` / `overview.md` / `architecture.md` / `legal_text_spec.md` / `SPEC_CICD.md` を入口とし、`SPEC.md` で要件と実装状況を補う構成が現状の実務的な落としどころです。見出しタグの規約は [specs.md](./specs.md) の `` `{@specs:heading-tags}` `` を参照。
