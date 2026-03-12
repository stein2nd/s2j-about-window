<!-- 
目的：「プロジェクトの存在理由、概要、基本情報」の明文化
 -->

# 概要

## 存在理由・スコープ

* **名称**: S2J About Window
* **Swift Package 名**: s2j-about-window
* **元リポジトリ**: [DCOAboutWindow](https://github.com/DangerCove/DCOAboutWindow)
* **目的**: AppKit ベースの「About Window」を SwiftUI で再実装し、macOS および iPadOS アプリケーション向けの共通コンポーネントとして提供する。
* **対応 OS**: macOS v12 以上、iPadOS v15 以上

## 準拠仕様

本ツールの設計は、以下の共通 SPEC に準拠します。

* [Swift/SwiftUI 共通仕様](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md)

技術スタック・開発ルール・国際化・コーディング規約・デザイン規約・テスト方針は、上記 COMMON_SPEC に従います。  
本リポジトリでは、**プロジェクト固有の仕様**のみを `docs/` 配下の各 spec で定義します。

## 関連ドキュメント

* 仕様の入口・一覧: [specs.md](./specs.md)
* 要件・実装状況・Backlog: [SPEC.md](./SPEC.md)
* CI/CD: [SPEC_CICD.md](./SPEC_CICD.md)
