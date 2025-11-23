#!/bin/bash
# ローカルでテストを実行するスクリプト（統合版）
# コミット前にCI/CDと同じテストを実行して問題を早期発見
# 
# このスクリプトは汎用的で、他のSwift Package Managerプロジェクトでも使用できます。
# 環境変数でカスタマイズ可能:
#   - SCHEME_NAME: Xcodeスキーム名（デフォルト: Package.swiftから自動検出）
#   - IOS_DEVICE: iOS/iPadOSシミュレーターデバイス名（デフォルト: "iPad Pro"）
#   - IOS_VERSION: iOS/iPadOS最小バージョン（デフォルト: "15.0"）
#   - SKIP_IOS_TESTS: iOS/iPadOSテストをスキップする場合は "true" を設定
#   - ENABLE_XCODE_PROJECT: Xcodeプロジェクト生成とテストを有効にする場合は "true" を設定（デフォルト: project.ymlが存在する場合に自動有効化）
#   - XCODE_PROJECT_NAME: Xcodeプロジェクト名（デフォルト: Package.swiftから自動検出、またはパッケージ名）
#   - XCODEGEN_AUTO_INSTALL: xcodegenを自動インストールする場合は "true" を設定（デフォルト: "false"）

set -e

echo "🧪 ローカルテスト実行スクリプト（統合版）"
echo "================================"

# カラー出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# エラーカウント
ERROR_COUNT=0

# テスト結果を記録
test_result() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
}

# Package.swiftからパッケージ名を取得
get_package_name() {
    if [ -f "Package.swift" ]; then
        grep -E "^[[:space:]]*name:" Package.swift | head -1 | sed -E 's/.*name:[[:space:]]*"([^"]+)".*/\1/' | xargs
    else
        echo ""
    fi
}

# Package.swiftからライブラリ名（スキーム名）を取得
get_library_name() {
    if [ -f "Package.swift" ]; then
        # .library(name: "LibraryName", ...) からライブラリ名を取得
        # 複数行にわたる可能性があるため、-A オプションで次の数行も取得
        grep -A 3 "\.library" Package.swift | grep -E "name:[[:space:]]*\"" | head -1 | sed -E 's/.*name:[[:space:]]*"([^"]+)".*/\1/' | xargs
    else
        echo ""
    fi
}

# Xcodeプロジェクト名を検出（.xcodeprojディレクトリから）
get_xcode_project_name() {
    # 既存の.xcodeprojを検索
    local project_file=$(find . -maxdepth 2 -name "*.xcodeproj" -type d | head -1)
    if [ -n "$project_file" ]; then
        basename "$project_file" .xcodeproj
    else
        # project.ymlから検出を試行
        if [ -f "project.yml" ]; then
            grep -E "^name:" project.yml | head -1 | sed -E 's/^name:[[:space:]]*"([^"]+)".*/\1/' | xargs || echo ""
        else
            echo ""
        fi
    fi
}

# パッケージ名を取得
PACKAGE_NAME=$(get_package_name)
# ライブラリ名（スキーム名）を取得（見つからない場合はパッケージ名を使用）
LIBRARY_NAME=$(get_library_name)
SCHEME_NAME="${SCHEME_NAME:-${LIBRARY_NAME:-${PACKAGE_NAME}}}"
IOS_DEVICE="${IOS_DEVICE:-iPad Pro}"
IOS_VERSION="${IOS_VERSION:-15.0}"
SKIP_IOS_TESTS="${SKIP_IOS_TESTS:-false}"

# Xcodeプロジェクト関連の設定
if [ -f "project.yml" ]; then
    # project.ymlが存在する場合、デフォルトでXcodeプロジェクト生成を有効化
    ENABLE_XCODE_PROJECT="${ENABLE_XCODE_PROJECT:-true}"
    # Xcodeプロジェクト名を自動検出
    XCODE_PROJECT_NAME="${XCODE_PROJECT_NAME:-$(get_xcode_project_name)}"
    # プロジェクト名が取得できない場合はパッケージ名を使用
    if [ -z "$XCODE_PROJECT_NAME" ]; then
        XCODE_PROJECT_NAME="$PACKAGE_NAME"
    fi
else
    ENABLE_XCODE_PROJECT="${ENABLE_XCODE_PROJECT:-false}"
    XCODE_PROJECT_NAME="${XCODE_PROJECT_NAME:-${PACKAGE_NAME}}"
fi

XCODEGEN_AUTO_INSTALL="${XCODEGEN_AUTO_INSTALL:-false}"

if [ -n "$PACKAGE_NAME" ]; then
    echo -e "${BLUE}📦 パッケージ名: ${PACKAGE_NAME}${NC}"
    echo -e "${BLUE}📋 スキーム名: ${SCHEME_NAME}${NC}"
    if [ "$ENABLE_XCODE_PROJECT" = "true" ]; then
        echo -e "${BLUE}📱 Xcodeプロジェクト名: ${XCODE_PROJECT_NAME}${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Package.swiftが見つかりません。Swift Package Managerプロジェクトであることを確認してください。${NC}"
fi

# 1. Swift Package テスト（macOS）
echo ""
echo -e "${BLUE}📦 Swift Package テストを実行中（macOS）...${NC}"
if swift test --enable-code-coverage; then
    test_result "Swift Package テスト (macOS)"
else
    test_result "Swift Package テスト (macOS)"
    echo -e "${YELLOW}⚠️  Swift Package テストに失敗しました。${NC}"
fi

# 2. Xcodeプロジェクトの生成とテスト（macOS）- オプション
if [ "$ENABLE_XCODE_PROJECT" = "true" ]; then
    echo ""
    echo -e "${BLUE}📱 Xcodeプロジェクトの生成とテストを実行中（macOS）...${NC}"

    # xcodegenの確認とインストール
    if ! command -v xcodegen &> /dev/null; then
        if [ "$XCODEGEN_AUTO_INSTALL" = "true" ]; then
            echo -e "${YELLOW}⚠️  xcodegen が見つかりません。インストールを試みます...${NC}"
            if command -v brew &> /dev/null; then
                brew install xcodegen
                test_result "xcodegen インストール"
            else
                echo -e "${YELLOW}⚠️  brew が見つかりません。xcodegen を手動でインストールしてください: brew install xcodegen${NC}"
                echo -e "${YELLOW}⚠️  Xcodeプロジェクトテストをスキップします。${NC}"
                ENABLE_XCODE_PROJECT="false"
            fi
        else
            echo -e "${YELLOW}⚠️  xcodegen が見つかりません。${NC}"
            echo -e "${YELLOW}   インストールするには: brew install xcodegen${NC}"
            echo -e "${YELLOW}   または環境変数 XCODEGEN_AUTO_INSTALL=true を設定してください。${NC}"
            echo -e "${YELLOW}⚠️  Xcodeプロジェクトテストをスキップします。${NC}"
            ENABLE_XCODE_PROJECT="false"
        fi
    fi

    if [ "$ENABLE_XCODE_PROJECT" = "true" ]; then
        # project.ymlの確認
        if [ -f "project.yml" ]; then
            echo -e "${GREEN}✅ project.yml が見つかりました${NC}"

            # Xcodeプロジェクトの生成
            echo ""
            echo "Xcodeプロジェクトを生成中..."
            if xcodegen generate; then
                test_result "Xcodeプロジェクト生成"

                # 生成されたプロジェクトファイルを確認
                XCODE_PROJECT_PATH="${XCODE_PROJECT_NAME}.xcodeproj"
                if [ -d "$XCODE_PROJECT_PATH" ] || [ -f "$XCODE_PROJECT_PATH/project.pbxproj" ]; then
                    echo ""
                    echo "Xcodeプロジェクトのテストを実行中（macOS）..."
                    if xcodebuild test \
                        -project "$XCODE_PROJECT_PATH" \
                        -scheme "$SCHEME_NAME" \
                        -destination 'platform=macOS' \
                        -enableCodeCoverage YES \
                        -quiet; then
                        test_result "Xcodeプロジェクトテスト (macOS)"
                    else
                        test_result "Xcodeプロジェクトテスト (macOS)"
                        echo -e "${YELLOW}⚠️  Xcodeプロジェクトのテストに失敗しました。${NC}"
                    fi
                else
                    echo -e "${YELLOW}⚠️  ${XCODE_PROJECT_PATH} が見つかりません。Xcodeプロジェクトの生成に失敗した可能性があります。${NC}"
                    ERROR_COUNT=$((ERROR_COUNT + 1))
                fi
            else
                test_result "Xcodeプロジェクト生成"
                echo -e "${YELLOW}⚠️  Xcodeプロジェクトの生成に失敗しました。${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️  project.yml が見つかりません。Xcodeプロジェクトテストをスキップします。${NC}"
        fi
    fi
fi

# 3. iOS/iPadOS シミュレーターの確認とテスト（オプション）
if [ "$SKIP_IOS_TESTS" != "true" ]; then
    echo ""
    echo -e "${BLUE}📱 iOS/iPadOS シミュレーターの確認中...${NC}"
    if ! command -v xcrun &> /dev/null; then
        echo -e "${YELLOW}⚠️  xcrun が見つかりません。Xcodeがインストールされているか確認してください。${NC}"
    else
        # 利用可能なシミュレーターを確認
        AVAILABLE_DEVICES=$(xcrun simctl list devices available | grep -i "$IOS_DEVICE" | head -1)
        if [ -z "$AVAILABLE_DEVICES" ]; then
            echo -e "${YELLOW}⚠️  ${IOS_DEVICE} シミュレーターが見つかりません。${NC}"
            echo "利用可能なデバイス:"
            xcrun simctl list devices available | grep -i "iPad\|iPhone" | head -5
        else
            echo -e "${GREEN}✅ ${IOS_DEVICE} シミュレーターが見つかりました${NC}"
            echo "$AVAILABLE_DEVICES"
            # デバイス名を抽出（最初に見つかったもの）
            DEVICE_NAME=$(echo "$AVAILABLE_DEVICES" | sed -E 's/.*\(([^)]+)\)/\1/' | head -1)
            if [ -n "$DEVICE_NAME" ]; then
                FULL_DEVICE_NAME=$(echo "$AVAILABLE_DEVICES" | sed -E 's/.*\(([^)]+)\)/iPad Pro (\1)/' | head -1 | xargs)
                echo -e "${BLUE}   使用デバイス: ${FULL_DEVICE_NAME}${NC}"
            fi
        fi
    fi

    # iOS/iPadOS テスト（オプション - Xcodeが必要）
    echo ""
    echo -e "${BLUE}📱 iOS/iPadOS テストを実行中（オプション）...${NC}"
    if command -v xcodebuild &> /dev/null; then
        # iOS SDKパスを取得
        IOS_SDK_PATH=$(xcrun --show-sdk-path --sdk iphonesimulator 2>/dev/null || echo "")

        if [ -n "$IOS_SDK_PATH" ]; then
            # パッケージをビルドして確認
            echo "iOS/iPadOS向けビルドを確認中..."
            TARGET="arm64-apple-ios${IOS_VERSION}-simulator"
            if swift build -Xswiftc -sdk -Xswiftc "$IOS_SDK_PATH" -Xswiftc -target -Xswiftc "$TARGET" 2>&1; then
                test_result "iOS/iPadOS ビルド"
            else
                echo -e "${YELLOW}⚠️  iOS/iPadOS ビルドに失敗しました（Xcodeプロジェクトが必要な可能性があります）${NC}"
            fi

            # xcodebuild test を試行
            # まずSwift Packageとして試行、次にXcodeプロジェクトとして試行
            if [ -n "$SCHEME_NAME" ]; then
                # デバイス UDID を取得
                DEVICE_UDID=$(xcrun simctl list devices available | grep -i "$IOS_DEVICE" | head -1 | sed -E 's/.*\(([^)]+)\)/\1/' | xargs)

                if [ -z "$DEVICE_UDID" ]; then
                    # iPad Pro が見つからない場合、任意の iPad を探す
                    DEVICE_UDID=$(xcrun simctl list devices available | grep -i "iPad" | head -1 | sed -E 's/.*\(([^)]+)\)/\1/' | xargs)
                fi

                if [ -z "$DEVICE_UDID" ]; then
                    echo -e "${YELLOW}⚠️  利用可能な iOS/iPadOS シミュレーターが見つかりません${NC}"
                    echo "利用可能なデバイス:"
                    xcrun simctl list devices available | grep -i "iPad\|iPhone" | head -10
                else
                    # シミュレーターを起動
                    echo "シミュレーターを起動中: $DEVICE_UDID"
                    xcrun simctl boot "$DEVICE_UDID" 2>/dev/null || true

                    # デバイス名を取得（表示用）
                    DEVICE_NAME=$(xcrun simctl list devices available | grep "$DEVICE_UDID" | sed -E 's/^[[:space:]]*([^(]+).*/\1/' | xargs)

                    # 1. Swift Packageとしてテストを試行
                    echo "xcodebuild test を試行中（Swift Package、スキーム: ${SCHEME_NAME}, デバイス: ${DEVICE_NAME} (${DEVICE_UDID})）..."
                    if xcodebuild test -package . -scheme "$SCHEME_NAME" -destination "platform=iOS Simulator,id=$DEVICE_UDID" -enableCodeCoverage YES 2>&1; then
                        test_result "iOS/iPadOS テスト (xcodebuild - Swift Package)"
                    else
                        # 2. Xcodeプロジェクトとしてテストを試行（プロジェクトが存在する場合）
                        if [ "$ENABLE_XCODE_PROJECT" = "true" ] && [ -d "${XCODE_PROJECT_NAME}.xcodeproj" ]; then
                            echo "xcodebuild test を試行中（Xcodeプロジェクト、スキーム: ${SCHEME_NAME}, デバイス: ${DEVICE_NAME} (${DEVICE_UDID})）..."
                            if xcodebuild test \
                                -project "${XCODE_PROJECT_NAME}.xcodeproj" \
                                -scheme "$SCHEME_NAME" \
                                -destination "platform=iOS Simulator,id=$DEVICE_UDID" \
                                -enableCodeCoverage YES \
                                -quiet; then
                                test_result "iOS/iPadOS テスト (xcodebuild - Xcodeプロジェクト)"
                            else
                                echo -e "${YELLOW}⚠️  xcodebuild test に失敗しました${NC}"
                                echo "   XcodeでPackage.swiftを開いて、手動でテストを実行してください:"
                                echo "   open Package.swift"
                            fi
                        else
                            echo -e "${YELLOW}⚠️  xcodebuild test に失敗しました（Swift Package）${NC}"
                            if [ "$ENABLE_XCODE_PROJECT" != "true" ]; then
                                echo -e "${YELLOW}   Xcodeプロジェクトが無効になっています。${NC}"
                            fi
                            echo "   XcodeでPackage.swiftを開いて、手動でテストを実行してください:"
                            echo "   open Package.swift"
                        fi
                    fi
                fi
            else
                echo -e "${YELLOW}⚠️  スキーム名が取得できませんでした。xcodebuild test をスキップします。${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️  iOS/iPadOS SDKが見つかりません。${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  xcodebuild が見つかりません。Xcodeがインストールされているか確認してください。${NC}"
    fi
else
    echo ""
    echo -e "${YELLOW}⚠️  iOS/iPadOS テストはスキップされます（SKIP_IOS_TESTS=true）${NC}"
fi

# 結果サマリー
echo ""
echo "================================"
if [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ すべてのテストが成功しました！${NC}"
    exit 0
else
    echo -e "${RED}❌ $ERROR_COUNT 個のテストが失敗しました${NC}"
    echo ""
    echo "💡 ヒント:"
    echo "   - XcodeでPackage.swiftを開いてテストを実行: open Package.swift"
    if [ -n "$PACKAGE_NAME" ]; then
        echo "   - 特定のテストのみ実行: swift test --filter <TestClassName>"
    fi
    if [ "$ENABLE_XCODE_PROJECT" = "true" ] && [ -d "${XCODE_PROJECT_NAME}.xcodeproj" ]; then
        echo "   - Xcodeプロジェクトを開く: open ${XCODE_PROJECT_NAME}.xcodeproj"
    fi
    echo "   - 環境変数でカスタマイズ:"
    echo "     SCHEME_NAME=<scheme> IOS_DEVICE=<device> IOS_VERSION=<version> \\"
    echo "     SKIP_IOS_TESTS=true ENABLE_XCODE_PROJECT=true XCODEGEN_AUTO_INSTALL=true \\"
    echo "     ./scripts/test-local.sh"
    exit 1
fi
