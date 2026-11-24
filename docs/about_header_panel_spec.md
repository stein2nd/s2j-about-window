# S2J About Window — About ヘッダーパネル強化

Issue: [#18](https://github.com/stein2nd/s2j-about-window/issues/18) (**完了** — 実装 v3.0.11、ホスト受け入れ [s2j-cozy-brew](https://github.com/stein2nd/s2j-cozy-brew) で確認済み)

**きっかけ:** 利用側 [s2j-cozy-brew](https://github.com/stein2nd/s2j-cozy-brew) の About UX 改善検討。参照 UI は DigiDNA **[iMazing](https://imazing.com/ja/backup-iphone-ipad)** の About パネル (大アイコン左・メタ情報右・下段にアクション)。  
**現状実装:** `AboutView` は縦積み、アイコン64pt、`Version {short}` のみ、本文 Markdown、License / Acknowledgements ボタン ([`AboutView.swift`](../Sources/S2JAboutWindow/AboutView.swift))。

設計上の決定経緯は [docs_mod/about_header_status.md](../docs_mod/about_header_status.md) を参照してください。

---

## 1. 目的とスコープ `{@about_header_panel_spec:s1}`

### 1.1. 目的 `{@about_header_panel_spec:s1-1}`

macOS の **クラシック About パネル** に近い情報密度とレイアウトを、**後方互換を保ったオプション** として提供します。

| 領域 | 現状 (v3.x) | 目標 (本仕様) |
| --- | --- | --- |
| レイアウト | 縦: アイコン → 名・版・著作権 → 本文 | **オプション** で横: **大アイコン \| メタ情報** |
| アイコン | 64×64 | 設定可能 (推奨デフォルト **128**、上限 Should で明記) |
| バージョン | `CFBundleShortVersionString` のみ | **`3.6.5 (24380)`** 形式 (ビルドは `CFBundleVersion` または明示) |
| カスタム枠 | なし | バッジ画像・任意 SwiftUI (例: Swiss Made 相当) |
| 識別子 | なし | **UUID** 等のサポート用1行 (オプション) |
| 下段アクション | License / Acknowledgements | 既存に加え **任意プライマリリンク** (例: 会社 Site、GitHub) |
| 短い説明 | Markdown 本文 | **維持** (iMazing 型より情報量を落とさない) |

### 1.2. 非目標 `{@about_header_panel_spec:s1-2}`

* `AboutWindow` (`NSWindow`) の AppKit レイアウト全面差し替え (初版は **`AboutView` / `aboutSheet` 中心**)。
* ホストが About を完全カスタム View で置き換える API (別 Issue)。
* テレメトリ送信・ライセンス検証。
* iMazing の UI をピクセル単位で複製すること。

### 1.3. 参照マッピング (iMazing → S2J) `{@about_header_panel_spec:s1-3}`

| iMazing 要素 | S2J 既存 | 本仕様での扱い |
| --- | --- | --- |
| 大アイコン (左) | 64pt 上段中央 | **ヘッダースタイル `.classicHorizontal`** |
| 名 / 版 (build) / 著作権 | ヘッダー VStack | 右カラム。バージョン行に build を括弧付き **Should** |
| カスタム画像 | — | `headerAccessory` (画像名または View) **Could → Should** |
| UUID | — | `supportIdentifier` **Could** |
| 下段左 Web | — | `primaryExternalLink` (タイトル + URL) **Should** |
| 下段右 OSS | Acknowledgements | 既存 `acknowledgementsResourceName` **Must 維持** |
| Short Description | Markdown 本文 | **Must 維持** (ヘッダー直下または本文先頭) |

---

## 2. 要件 `{@about_header_panel_spec:s2}`

凡例: **Must** / **Should** / **Could** ([SPEC.md](../docs/SPEC.md) と同じ)

### 2.1. 機能要件 `{@about_header_panel_spec:s2-1}`

| ID | レベル | 内容 |
| --- | --- | --- |
| AHP-01 | **Must** | デフォルトの `AboutView` 初期化は **現行レイアウト (`vertical`) のまま** 振る舞いが変わらない (既存スナップショット・利用側互換)。 |
| AHP-02 | **Should** | `AboutHeaderStyle` (仮) で `.vertical` / `.classicHorizontal` を選択できる。 |
| AHP-03 | **Should** | `showBuildNumber: Bool` (または `versionDisplay: .marketingOnly \| .marketingAndBuild`) で `Version 1.0.23 (4)` 形式を表示できる。ビルド源は `CFBundleVersion`、上書き文字列も可。 |
| AHP-04 | **Should** | `iconSideLength: CGFloat?` でアイコン辺長を指定できる。未指定時はスタイルごとのデフォルト (vertical: 64、classic: 128)。 |
| AHP-05 | **Could** | `supportIdentifier: String?` をヘッダーに1行表示 (ラベルはローカライズ、例: `UUID:` / 汎用 `Identifier:`)。 |
| AHP-06 | **Could** | `headerAccessoryImageName: String?` + `accessoryBundle: Bundle` で、アイコン下またはメタ列内に画像を表示。 |
| AHP-07 | **Should** | `primaryLink: (title: String, url: URL)?` で下段 (License / Ack と同列) に **1本** のリンクボタンを左寄せまたは HStack 先頭に配置できる。複数リンクは **初版では Markdown 本文に任せる** (§8 #2)。 |
| AHP-07b | **Should** | 下段 (License / Ack / `primaryLink`) が横幅に収まらないとき、**縦積みレイアウト** にフォールバックする (§8 #1)。 |
| AHP-08 | **Must** | `aboutSheet` / `aboutPopover` / macOS `AboutWindow` 経由でも **同じヘッダーオプション** を渡せる (既存 Legal 引数と直交)。 |
| AHP-08b | **Should** | iOS: **iPhone 等の狭いシート** ではヘッダーは `.vertical` (縦積み)。**iPad で横に余裕がある場合** は `classicHorizontal` を許可 (§8 #3)。 |
| AHP-09 | **Must** | アクセシビリティ: アイコン、バージョン、著作権、UUID、各ボタンに `accessibilityLabel` を付与。 |

### 2.2. 非機能要件 `{@about_header_panel_spec:s2-2}`

| ID | レベル | 内容 |
| --- | --- | --- |
| AHP-NF-01 | **Must** | 最小ウィンドウサイズ (現行 `minWidth: 400` 等) を壊さない。横レイアウト時は `minWidth` を **Should** で480前後に引き上げ可能。macOS `AboutWindow` の初期サイズ・`defaultSize` は **host が調整可能** (§8 #4)。 |
| AHP-NF-02 | **Must** | VoiceOver / Dynamic Type でメタ行が読める (バージョン行は1要素として読み上げ)。 |
| AHP-NF-03 | **Should** | Snapshot テストを **classicHorizontal** 用に追加 (`AboutViewSnapshotTests`)。 |

---

## 3. API `{@about_header_panel_spec:s3}`

```swift
public enum AboutHeaderStyle: Sendable {
    case vertical          // デフォルト (v3互換)
    case classicHorizontal // iMazing 型: 左アイコン・右メタ
}

public struct AboutHeaderOptions: Sendable {
    public var style: AboutHeaderStyle
    public var iconSideLength: CGFloat?
    public var showBuildNumber: Bool
    public var buildNumberOverride: String?
    public var supportIdentifier: String?
    public var headerAccessoryImageName: String?
    public var accessoryBundle: Bundle
    public var primaryLinkTitle: String?
    public var primaryLinkURL: URL?

    public static let `default` = AboutHeaderOptions(style: .vertical)
}

// AboutView に追加 (既存 init は headerOptions: .default)
public init(
    content: String,
    contentType: AboutContentType = .automatic,
    appName: String? = nil,
    version: String? = nil,
    copyright: String? = nil,
    headerOptions: AboutHeaderOptions = .default,
    licenseResourceName: String? = nil,
    acknowledgementsResourceName: String? = nil,
    resourceBundle: Bundle = .main
)
```

* `AboutViewModel` に `buildNumber` 読み取り (`CFBundleVersion`) を追加。表示文字列の組み立ては View または小さな Formatter に分離 **Should**。
* UUID はホストが `supportIdentifier` に渡す (バンドル UUID 自動取得は **Could**、プライバシー注記を README に)。

---

## 4. UI ワイヤ (classicHorizontal) `{@about_header_panel_spec:s4}`

```text
┌─────────────────────────────────────────────────────┐
│  ┌────────┐  App Name (title)                        │
│  │        │  Version 1.0.23 (4)                      │
│  │  Icon  │  [ accessory image optional ]            │
│  │ 128pt  │  Copyright © …                           │
│  └────────┘  UUID: … (optional, caption)             │
│                                                       │
│  ─── Markdown 本文 (Short Description + links) ───   │
│                                                       │
│  [ Primary Link ]     [ License… ] [ Acknowledgements]│
└─────────────────────────────────────────────────────┘
```

* License / Acknowledgements の配置・シート挙動は [legal_text_spec.md](./legal_text_spec.md) を変更しない。

---

## 5. 利用側 (s2j-cozy-brew) 想定 `{@about_header_panel_spec:s5}`

| 項目 | 値 (案) |
| --- | --- |
| `headerOptions.style` | `.classicHorizontal` |
| `showBuildNumber` | `true` (`package.json` buildNumber と `Info.plist` 同期済み) |
| `primaryLink` | 「GitHub Repository」→ `https://github.com/stein2nd/s2j-cozy-brew` |
| Markdown 本文 | 現行 `CozyBrewAbout.markdown` (短い説明を維持) |
| `supportIdentifier` | 初版は未設定または将来サポート用 |

---

## 6. フェーズ案 `{@about_header_panel_spec:s6}`

| フェーズ | 内容 | 出荷目安 |
| --- | --- | --- |
| **1** | `showBuildNumber` + `Bundle.buildNumber` ヘルパーのみ (レイアウトは vertical のまま) | マイナー |
| **2** | `AboutHeaderStyle.classicHorizontal` + 大アイコン | マイナー |
| **3** | `primaryLink`、accessory 画像、UUID 行 | マイナー |

**破壊的変更:** なし (opt-in のみ)。メジャー上げは不要想定。

---

## 7. テスト・受け入れ `{@about_header_panel_spec:s7}`

* **Must:** 既存 `AboutViewTests` / Snapshot が `headerOptions: .default` で緑。
* **Should:** classic + build 表示の Snapshot が1件以上。
* **Should:** `AboutHeaderOptions` の build 表示ユニットテスト (文字列組み立て)。

受け入れ (Issue 用):

1. SampleApp / プレビューで classicHorizontal が確認できる。
2. s2j-cozy-brew が pin 更新後、About でバージョン (build) と GitHub ボタンが期待どおり。
3. `npm run lint:docs` (両リポジトリ) および `swift test` (macOS) 通過。

---

## 8. 決定事項 (レビュー反映) `{@about_header_panel_spec:s8}`

2026-11-24レビューで確定。**未決なし**。

| # | 論点 | 決定 |
| --- | --- | --- |
| 1 | 下段3ボタンが狭いときの折り返し | **縦積みフォールバック** (HStack → VStack)。`ViewThatFits` は採用しない |
| 2 | `primaryLink` を複数にするか | **初版は1本**。複数は Markdown 本文のリンクに任せる |
| 3 | iOS `aboutSheet` でも classic を許すか | **iPad**: 横に余裕がある場合は `classicHorizontal` を許可。**iPhone 等**: **縦積み** (`.vertical`) |
| 4 | `AboutWindow.showAboutWindow` のデフォルトサイズ | classic 時も含め、**host が `defaultSize` / フレーム系パラメータで調整可能** |

実装メモ:

* #3: `horizontalSizeClass` / 利用可能幅で classic を自動フォールバックするか、host が `headerOptions.style` を明示指定するかは実装時に [architecture.md](./architecture.md) に記載 **Should**。
* #4: 破壊的変更を避けるため、既存 `showAboutWindow` にオプション引数追加が望ましい **Should**。
