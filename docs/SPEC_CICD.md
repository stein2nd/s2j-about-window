# CICD_SPEC.md (S2J About Window - CI/CD 仕様)

## はじめに

* 本ドキュメントでは、Swift Package「S2J About Window」の CI/CD 仕様を定義します。
* 本プロジェクトの CI/CD 設計は、以下の共通 SPEC に準拠します。
    * [Swift/SwiftUI プロジェクト向け共通仕様｜CI/CD workflow](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC_CICD.md)
* 以下は、本プロジェクト固有の CI/CD 仕様をまとめたものです。
* 詳細な実装状況については、[SPEC.md](./SPEC.md) を参照してください。

## 1. 概要

本プロジェクトでは、GitHub Actions を使用して CI/CD パイプラインを構築しています。

### 1.1. 実装状況

**実装状況**: ✅ **完全実装済み・テスト成功** - CI/CD ワークフローとローカルテスト・スクリプトの実装完了、GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功

### 1.2. 基本方針

* Swift Package のビルド成果物 (バイナリ / XCFramework) は Git 管理対象外とします。
* Universal Binary 化は SwiftPM のビルド・フェーズで自動処理されます。
* リリース用ビルドは GitHub Actions の CI ワークフローで生成し、Artifacts として管理します。
* CI/CD 環境 (GitHub Actions など) では bash が標準シェルとして使用されます。

### 1.3. ワークフロー構成

* **ワークフローファイル**: `.github/workflows/swift-test.yml`
* **トリガー**: `push` および `pull_request` イベント (`main`、`develop` ブランチ)
* **実行環境**: `macos-latest` (GitHub Actions の macOS Runner)
* **その他のワークフロー**:
  * `docs-linter.yml`: Markdown ドキュメントの表記揺れ検出 (Docs Linter)

### 1.4. ジョブ構成

本ワークフローは、以下の3つのジョブで構成されています。

1. **`test-macos`**: macOS 向けテスト実行
2. **`test-ios`**: iOS/iPadOS 向けテスト実行
3. **`build-release`**: リリースビルド生成

## 2. ジョブ詳細仕様

### 2.1. `test-macos` ジョブ

#### 2.1.1. 概要

* **目的**: macOS プラットフォーム向けのユニットテストを実行し、テスト・カバレッジを収集します。
* **実行環境**: `macos-latest`
* **依存関係**: なし (独立実行が可能)

#### 2.1.2. 実行ステップ

1. **Checkout**
   * `actions/checkout@v4` を使用してリポジトリをチェック・アウトします。

2. **Setup Xcode**
   * `maxim-lobanov/setup-xcode@v1` を使用して Xcode をセットアップします。
   * **Xcode バージョン**: `latest-stable` (最新の安定版)

3. **Run tests on macOS**
   * `swift test --enable-code-coverage` を実行して、macOS 向けのユニットテストを実行します。
   * テスト・カバレッジを有効化します。

4. **Upload coverage to Codecov**
   * `codecov/codecov-action@v3` を使用して、テスト・カバレッジを Codecov にアップロードします。
   * **設定**:
     * `file`: `.build/coverage/coverage.xml`
     * `flags`: `macos`
     * `name`: `macos-coverage`

#### 2.1.3. 期待される結果

* すべての macOS 向けユニットテストが成功すること。
* テスト・カバレッジが Codecov に正常にアップロードされること。

### 2.2. `test-ios` ジョブ

#### 2.2.1. 概要

* **目的**: iOS/iPadOS プラットフォーム向けのユニットテストを実行し、テスト・カバレッジを収集します。
* **実行環境**: `macos-latest`
* **タイムアウト**: `60分` (ビルド/シミュレーター起動で時間がかかる場合があるため)
* **依存関係**: なし (独立で実行可能)
* **環境変数**:
  * `LOG_DIR`: `/tmp/gha-ios-logs` (出力ログ保存先)

#### 2.2.2. 実行ステップ

1. **Checkout**
   * `actions/checkout@v4` を使用してリポジトリをチェック・アウトします。

2. **Xcode バージョンの選択 (フォールバック付き)**
   * 優先順位に従って、利用可能な Xcode バージョンを選択します。
   * **優先順位**: Xcode 26.1 → Xcode 26.0.1 → Xcode 16.4.0
   * **実装**: `maxim-lobanov/setup-xcode@v1` を使用し、各バージョンに対して `continue-on-error: true` を設定してフォールバックを実現します。
   * **注意**: 各セットアップ・ステップは失敗を許可し、利用可能な最初のバージョンを使用します。

3. **ログディレクトリの作成**
   * `$LOG_DIR` ディレクトリを作成します。

4. **環境検出: Xcode / SDKs / Simulators (ログ保存)**
   * Xcode バージョン、利用可能な SDK、シミュレーター・ランタイム、デバイス情報を検出し、ログに保存します。
   * **検出内容**:
     * `xcodebuild -version`
     * `/Applications` ディレクトリの内容
     * `xcodebuild -showsdks`
     * `xcrun simctl list runtimes`
     * `xcrun simctl list devices available`
   * **出力変数**:
     * `xcode_version`: 検出された Xcode バージョン
     * `has_ios_26_1`: iOS 26.1 ランタイムが利用可能かどうか
     * `has_ios_26_0`: iOS 26.0 ランタイムが利用可能かどうか
     * `has_ios_18_5`: iOS 18.5 ランタイムが利用可能かどうか

5. **Xcode アプリの強制選択 (優先順位付き)**
   * 優先順位に従って、利用可能な Xcode アプリを強制選択します。
   * **優先順位**:
     1. `/Applications/Xcode_26.1.app/Contents/Developer`
     2. `/Applications/Xcode_26.1.0.app/Contents/Developer`
     3. `/Applications/Xcode.app/Contents/Developer` (26.0.1 またはその他の可能性)
     4. `/Applications/Xcode_26.0.app/Contents/Developer`
     5. `/Applications/Xcode_16.4.0.app/Contents/Developer`
   * **実装**: `sudo xcode-select -s` を使用して Xcode を選択します。
   * **フォールバック**: 優先パスが見つからない場合は、`setup-xcode` の選択に依存します。

6. **Xcode とランタイムの再検出 (選択後)**
   * Xcode 選択後の状態を再検出し、ログに保存します。
   * **検出内容**:
     * `xcodebuild -version`
     * `xcodebuild -showsdks`
     * `xcrun simctl list runtimes`
     * `xcrun simctl list devices available`

7. **Swift Package の検証**
   * `swift package describe --type json` でパッケージ情報を確認します。
   * `swift package resolve` で依存関係を解決します。

8. **XcodeGen のインストール**
   * `brew install xcodegen` で XcodeGen をインストールします。

9. **Xcode プロジェクトの生成**
   * `project.yml` が存在する場合、`xcodegen generate` で Xcode プロジェクトを生成します。
   * **検証**: 生成されたスキーム・ファイル (`S2JAboutWindow-iOS.xcscheme`) の存在と内容を確認します。

10. **シミュレーター・ランタイムとデバイスの選択 (フォールバック付き)**
    * 優先順位に従って、利用可能な iOS シミュレーター・ランタイムとデバイスを選択します。
    * **ランタイム優先順位**: iOS 26.1 → iOS 26.0 → iOS 18.5 → 最初に利用可能な iOS ランタイム
    * **デバイス選択**:
      * まず、選択されたランタイムに対応するデバイスを検索します。
      * 見つからない場合は、優先デバイス名 (`iPhone 17`、`iPhone 16e`、`iPhone 16`、`iPad Air`、`iPad Pro`、`iPad (A16)`) から選択します。
      * それでも見つからない場合は、最初に利用可能な iPhone または iPad を選択します。
    * **出力変数**:
      * `udid`: 選択されたデバイスの UDID
      * `name`: 選択されたデバイスの名前
      * `runtime`: 選択されたランタイム
      * `device_line`: 選択されたデバイスの行

11. **シミュレーターの起動 (ポーリング付き)**
    * 選択されたシミュレーターを起動します。
    * **実装**:
      * `xcrun simctl boot` でシミュレーターを起動します。
      * `open -a Simulator` で Simulator アプリを開きます。
      * 最大60回 (約2分) ポーリングして、シミュレーターが起動するまで待機します。
    * **出力変数**:
      * `booted_udid`: 起動されたシミュレーターの UDID

12. **デバッグ: デスティネーションとビルド設定の表示**
    * `xcodebuild -showdestinations` で利用可能なデスティネーションを確認します。
    * `xcodebuild -showBuildSettings` でビルド設定を確認します。
    * ログに保存します。

13. **ランタイムバージョンの抽出と SDK の自動検出**
    * シミュレーターのランタイム・バージョンを抽出します (例: `iOS 26.0` → `26.0`)。
    * `xcodebuild -showsdks` で利用可能な iOS Simulator SDK を確認します。
    * ランタイム・バージョンと一致する SDK を自動検出します (例: `iphonesimulator26.0` for iOS 26.0)。
    * 完全一致が見つからない場合は、メジャー・バージョンで一致する SDK を検索します。
    * それでも見つからない場合は、任意の `iphonesimulator` SDK を使用します。

14. **デスティネーションの構築**
    * `xcodebuild -showdestinations` の出力から、UDID に一致するデスティネーションを検索します。
    * 見つからない場合は、デスティネーションを手動で構築します。
    * **重要**: OS バージョンを指定せず、UDID のみを使用します (`platform=iOS Simulator,id=<UDID>`)。
      * これにより、xcodebuild が自動的に適切な SDK/ランタイムをマッチングします。
      * SDK とランタイムのバージョン不一致の問題を回避します。

15. **ビルドとテスト実行 (マルチ・ストラテジー)**
    * 複数のアプローチでテストを実行します。
    * **ストラテジー A**: `xcodebuild test-without-building` (SDK 指定なし、xcodebuild が自動選択)
      * 成功した場合は終了します。
      * 失敗した場合は、ストラテジー A-2 に進みます。
    * **ストラテジー A-2**: `xcodebuild test-without-building` (検出された SDK を明示的に指定)
      * 成功した場合は終了します。
      * 失敗した場合は、ストラテジー B に進みます。
    * **ストラテジー B**: `xcodebuild test` (SDK 指定なし、xcodebuild が自動選択)
      * 成功した場合は終了します。
      * 失敗した場合は、ストラテジー B-2 に進みます。
    * **ストラテジー B-2**: `xcodebuild test` (検出された SDK を明示的に指定)
      * 成功した場合は終了します。
    * **共通設定**:
      * `-project s2j-about-window.xcodeproj`
      * `-scheme S2JAboutWindow-iOS`
      * `-destination`: 選択されたデバイス (UDID のみ、OS バージョンは指定しない)
      * `-enableCodeCoverage YES`
      * `-resultBundlePath`: `$LOG_DIR/result.xcresult`
    * **結果バンドルの処理**:
      * テスト実行後、結果バンドルが存在する場合、以下の情報を抽出します。
        * `xcrun xcresulttool get --path "$RESULT_BUNDLE" --format json`: JSON 形式の結果
        * `xcrun xccov view --report "$RESULT_BUNDLE"`: カバレッジ・レポート

16. **診断情報のアップロード (アーティファクト)**
    * `actions/upload-artifact@v4` を使用して、診断情報をアーティファクトとしてアップロードします。
    * **アーティファクト名**: `ios-test-diagnostics`
    * **パス**: `$LOG_DIR` (すべてのログファイルを含む)
    * **条件**: `if: ${{ always() }}` (テストが失敗しても実行)

17. **カバレッジのアップロード (Codecov) (ベスト・エフォート)**
    * `codecov/codecov-action@v3` を使用して、テスト・カバレッジを Codecov にアップロードします。
    * **設定**:
      * `file`: `.build/coverage/coverage.xml`
      * `flags`: `ios`
      * `name`: `ios-coverage`
      * `fail_ci_if_error`: `false` (失敗しても CI を継続)
    * **条件**: `if: ${{ always() }}` (テストが失敗しても実行)

#### 2.2.3. 期待される結果

* すべての iOS/iPadOS 向けユニットテストが成功すること。
* テストカバレッジが Codecov に正常にアップロードされること (失敗しても CI は継続)。
* 診断情報がアーティファクトとして保存されること。

#### 2.2.4. 堅牢性の特徴

* **Xcode バージョンのフォールバック**: 複数の Xcode バージョンを試行し、利用可能な最初のバージョンを使用します。
* **シミュレーター・ランタイムのフォールバック**: 複数の iOS ランタイムを試行し、利用可能な最初のランタイムを使用します。
* **デバイス選択のフォールバック**: 複数のデバイス名を試行し、利用可能な最初のデバイスを使用します。
* **SDK とランタイムの自動マッチング**: ランタイム・バージョンと一致する SDK を自動検出し、SDK とランタイムのバージョン不一致の問題を回避します。
* **デスティネーション構築の改善**: OS バージョンを指定せず、UDID のみを使用することで、xcodebuild が自動的に適切な SDK/ランタイムをマッチングします。
* **テスト実行のマルチ・ストラテジー**: 複数のアプローチでテストを実行し、いずれかが成功すれば CI を継続します。SDK を指定せずに実行を優先し、xcodebuild の自動選択を活用します。
* **詳細なログ記録**: すべてのステップでログを記録し、アーティファクトとして保存します。
* **診断情報の常時アップロード**: テストが失敗しても診断情報をアップロードし、問題の特定を容易にします。

### 2.3. `build-release` ジョブ

#### 2.3.1. 概要

* **目的**: リリース用の Universal Binary をビルドし、ビルド成果物をアーティファクトとして保存します。
* **実行環境**: `macos-latest`
* **依存関係**: `test-macos` および `test-ios` ジョブが成功した後に実行されます (`needs: [test-macos, test-ios]`)

#### 2.3.2. 実行ステップ

1. **Checkout**
   * `actions/checkout@v4` を使用してリポジトリをチェック・アウトします。

2. **Setup Xcode**
   * `maxim-lobanov/setup-xcode@v1` を使用して Xcode をセットアップします。
   * **Xcode バージョン**: `latest-stable` (最新の安定版)

3. **Build Universal Binary**
   * `swift build -c release` を実行して、リリース用の Universal Binary をビルドします。

4. **Upload build artifacts**
   * `actions/upload-artifact@v4` を使用して、ビルド成果物をアーティファクトとしてアップロードします。
   * **アーティファクト名**: `s2j-about-window-build`
   * **パス**: `.build/release/`

#### 2.3.3. 期待される結果

* リリース用の Universal Binary が正常にビルドされること。
* ビルド成果物がアーティファクトとして保存されること。

## 3. ローカルテスト・スクリプト

### 3.1. 概要

**実装状況**: ✅ **完全実装済み** - `scripts/test-local.sh` の統合版実装完了

* **スクリプト**: `scripts/test-local.sh`
* **目的**: コミット前に CI/CD と同じテストをローカルで実行します。
* **汎用性**: 他の Swift Package Manager プロジェクトでも使用可能
* **互換性**: CI/CD 環境 (bash) とローカル環境 (zsh) の両方で動作します。

### 3.2. 実行方法

* **直接実行**: `./scripts/test-local.sh [オプション]` (macOS では zsh から実行可能)
* **npm スクリプトから実行**: `npm run test:local -- [オプション]`

### 3.3. 設定の優先順位

1. コマンドライン引数
2. 自動検出 (Package.swift から)
3. 環境変数
4. デフォルト値

### 3.4. 自動検出機能

* `Package.swift` からパッケージ名とライブラリ名を自動検出
* Xcode プロジェクト名の自動検出 (`.xcodeproj` ディレクトリまたは `project.yml` から)
* iOS シミュレーター・デバイスの自動検出

### 3.5. コマンドライン引数によるカスタマイズ

* `-s, --scheme-name <name>`: Xcode スキーム名
* `-d, --ios-device <device>`: iOS/iPadOS シミュレーター・デバイス名
* `-v, --ios-version <version>`: iOS/iPadOS 最小バージョン
* `--skip-ios`: iOS/iPadOS テストをスキップ
* `--enable-xcode-project`: Xcode プロジェクト生成とテストを有効化
* `--xcode-project-name <name>`: Xcode プロジェクト名
* `--xcodegen-auto-install`: `xcodegen` を自動インストール
* `-h, --help`: ヘルプを表示

### 3.6. 環境変数によるカスタマイズ

引数と自動検出が優先されます。

* `SCHEME_NAME`: Xcode スキーム名 (デフォルト: Package.swift から自動検出)
* `IOS_DEVICE`: iOS シミュレーター・デバイス名 (デフォルト: "iPad Pro")
* `IOS_VERSION`: iOS 最小バージョン (デフォルト: "15.0")
* `SKIP_IOS_TESTS`: iOS テストをスキップする場合は "true"
* `ENABLE_XCODE_PROJECT`: Xcode プロジェクト生成とテストを有効化 (デフォルト: `project.yml` が存在する場合に自動有効化)
* `XCODE_PROJECT_NAME`: Xcode プロジェクト名 (デフォルト: 自動検出)
* `XCODEGEN_AUTO_INSTALL`: `xcodegen` を自動インストールする場合は "true" (デフォルト: "false")

### 3.7. 実行内容

#### 3.7.1. Swift Package テスト (macOS)

* `swift test --enable-code-coverage` を実行

#### 3.7.2. Xcode プロジェクトの生成とテスト (オプション)

`project.yml` が存在する場合に実行されます。

* `xcodegen generate` で Xcode プロジェクトを生成
* **プラットフォーム専用スキームの自動選択**:
  * macOS テスト実行時: `S2JAboutWindow-macOS` スキームが存在する場合は自動選択 (macOS ターゲットのみをビルド・テスト)
  * iOS テスト実行時: `S2JAboutWindow-iOS` スキームが存在する場合は自動選択 (iOS ターゲットのみをビルド・テスト)
  * 専用スキームが存在しない場合は、統合スキーム (`S2JAboutWindow`) を使用
* `xcodebuild test -project <project> -scheme <scheme> -destination 'platform=macOS'` でテスト実行

#### 3.7.3. iOS/iPadOS シミュレーターの確認とテスト (オプション)

* 利用可能なシミュレーターを確認
* **デバイス ID の取得**: UUID 形式 (8-4-4-4-12) で正しく抽出
* **シミュレーターの起動**: 既に起動済みの場合はスキップ、未起動の場合は自動起動
* iOS/iPadOS 向けビルドの確認 (`swift build -Xswiftc -sdk ... -Xswiftc -target ...`)
* Swift Package として `xcodebuild test` を試行
* Xcode プロジェクトが存在する場合は、Xcode プロジェクトとしても `xcodebuild test` を試行 (プラットフォーム専用スキームを自動選択)

#### 3.7.4. エラー・ハンドリング

* **詳細なエラー・メッセージとデバッグ情報の表示**: 各ステップで適切なログとエラーメッセージを出力

### 3.8. CI/CD との整合性

* **macOS テスト**: `swift test --enable-code-coverage` を実行 (CI/CD と同じ)
* **iOS テスト**: Xcode プロジェクトの生成、シミュレーターの起動、`xcodebuild test` の実行 (CI/CD と同じ)

## 4. テスト・カバレッジ

### 4.1. カバレッジ収集

* **macOS**: `swift test --enable-code-coverage` でカバレッジを収集します。
* **iOS**: `xcodebuild test -enableCodeCoverage YES` でカバレッジを収集します。

### 4.2. カバレッジ・アップロード

* **サービス**: Codecov
* **macOS カバレッジ**: `flags: macos`、`name: macos-coverage`
* **iOS カバレッジ**: `flags: ios`、`name: ios-coverage`、`fail_ci_if_error: false`

## 5. ビルド成果物

### 5.1. リリース・ビルド

* **パス**: `.build/release/`
* **形式**: Universal Binary (Swift Package Manager が自動生成)
* **アーティファクト名**: `s2j-about-window-build`

### 5.2. 診断情報

* **パス**: `/tmp/gha-ios-logs` (iOS テスト・ジョブのみ)
* **アーティファクト名**: `ios-test-diagnostics`
* **内容**:
  * Xcode バージョン情報
  * SDK 情報
  * シミュレーター・ランタイム情報
  * デバイス情報
  * テスト実行ログ
  * 結果バンドル (`result.xcresult`)

## 6. エラー・ハンドリング

### 6.1. テスト失敗時の動作

* **macOS テスト**: テストが失敗した場合、ジョブは失敗します。
* **iOS テスト**: テストが失敗した場合、診断情報がアーティファクトとして保存され、CI は失敗します。
* **カバレッジ・アップロード**: iOS テストのカバレッジ・アップロードが失敗した場合でも、CI は継続します (`fail_ci_if_error: false`)。

### 6.2. ビルド失敗時の動作

* **リリース・ビルド**: ビルドが失敗した場合、ジョブは失敗します。

## 7. 実装状況

### 7.1. 完全実装済み機能

以下の機能は完全に実装され、テストも完了しています。

* **GitHub Actions ワークフロー**:
  * `swift-test.yml`: Swift Package のユニットテストおよび UI スナップショット・テストの自動実行 (✅100% 実装完了・テスト成功)
  * `test-macos` ジョブ: macOS 向けテスト実行とカバレッジ収集
  * `test-ios` ジョブ: iOS/iPadOS 向けテスト実行とカバレッジ収集
    * ランタイム・バージョンの抽出と SDK の自動検出機能 (✅実装完了)
    * デスティネーション構築の改善 (OS バージョンを指定せず、UDID のみを使用) (✅実装完了)
    * テスト実行の優先順位の最適化 (SDK を指定せずに実行を優先) (✅実装完了)
    * 診断情報の常時アップロード (`if: always()` を追加) (✅実装完了)
  * `build-release` ジョブ: リリースビルド生成
* **ローカルテスト・スクリプト**:
  * `scripts/test-local.sh`: コミット前に CI/CD と同じテストをローカルで実行 (✅100% 実装完了)
  * 汎用的で、他の Swift Package Manager プロジェクトでも使用可能
  * プラットフォーム専用スキームの自動選択機能
  * シミュレーター管理の改善 (デバイス ID の取得、起動状態の確認)

### 7.2. 実装完了率

**CI/CD**: 100% 実装完了・テスト成功

* GitHub Actions ワークフローとローカルテスト・スクリプトの実装完了
* GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功

## 8. 今後の改善予定

### 8.1. 短期での改善予定 (1-3ヵ月)

* **テスト・カバレッジの向上**: 現在のテスト・カバレッジを向上させ、目標値 (70%以上) を達成します。
* **UI テストの追加**: SnapshotTesting フレームワークを使用した UI テストを追加します。

### 8.2. 中期での改善予定 (3-6ヵ月)

* **並列実行の最適化**: `test-macos` と `test-ios` ジョブを並列実行し、CI 時間を短縮します。
* **キャッシュの活用**: Swift Package の依存関係をキャッシュし、ビルド時間を短縮します。

---

## Appendix A: ワークフロー設定の詳細

### A.1. トリガー設定

```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
```

### A.2. ジョブ依存関係

```yaml
build-release:
  needs: [test-macos, test-ios]
```

### A.3. 環境変数

```yaml
test-ios:
  env:
    LOG_DIR: /tmp/gha-ios-logs
```

---

## Appendix B: 参考資料

* [GitHub Actions ドキュメント](https://docs.github.com/ja/actions)
* [Swift Package Manager ドキュメント](https://www.swift.org/package-manager/)
* [XcodeGen ドキュメント](https://github.com/yonaskolb/XcodeGen)
* [Codecov ドキュメント](https://docs.codecov.com/)
