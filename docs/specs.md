# 仕様書の起点 (S2J About Window)

本ドキュメントは、Swift Package「S2J About Window」の仕様の**入口**です。  
各トピックは以下のドキュメントに分割しています。AI 伴走やメンテ時は、該当する spec を参照してください。

| ドキュメント | 役割 |
|--------------|------|
| [概要](./overview.md) | プロジェクトの存在理由、概要、基本情報 |
| [アーキテクチャー](./architecture.md) | フォルダー構成、主要ファイル、技術スタック、ビルド、責務 |
| [SPEC.md](./SPEC.md) | 要件概要・実装状況サマリ・Backlog・品質評価・Appendix |
| [requirements.md](./requirements.md) | 機能要件・非機能要件（Must/Should/Could）の詳細（※将来分離時はここに集約） |
| [api_spec.md](./api_spec.md) | 公開 API の契約（AboutWindow / AboutView / aboutSheet / aboutPopover）（※将来分離時） |
| [content_spec.md](./content_spec.md) | コンテンツ形式（Markdown の扱い、フォールバック）（※将来分離時） |
| [localization_spec.md](./localization_spec.md) | ローカライズ（キー一覧、Bundle.module、AboutDefault.md）（※将来分離時） |
| [platform_spec.md](./platform_spec.md) | プラットフォーム別挙動（macOS / iPadOS）（※将来分離時） |
| [SPEC_CICD.md](./SPEC_CICD.md) | CI/CD 仕様（ワークフロー・ローカルテスト・カバレッジ） |
| [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md) | 仕様の細分化方針とベター・プラクティス |

※ 表中の「※将来分離時」は、現時点では [SPEC.md](./SPEC.md) に内容が含まれており、必要に応じて上記の独立 spec に切り出すことを想定しています。

## クイック参照

* **「なぜこのプロジェクトがあるか」** → [overview.md](./overview.md)
* **「何を Must/Should で作るか」** → [SPEC.md](./SPEC.md) §2, §4
* **「コードはどこに何を書くか」** → [architecture.md](./architecture.md)
* **「macOS / iPadOS で何が違うか」** → [SPEC.md](./SPEC.md) §4.1、[architecture.md](./architecture.md)
* **「CI やローカルテストの仕様」** → [SPEC_CICD.md](./SPEC_CICD.md)
* **「仕様をどう分割するかの方針」** → [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md)
