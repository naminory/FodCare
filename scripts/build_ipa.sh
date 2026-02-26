#!/bin/bash
set -e

cd "$(dirname "$0")/.."

echo "=== フォドケア IPA ビルド ==="

# 0. ビルド番号インクリメント
CURRENT=$(grep 'CURRENT_PROJECT_VERSION:' project.yml | awk '{print $2}')
NEXT=$((CURRENT + 1))
sed -i '' "s/CURRENT_PROJECT_VERSION: $CURRENT/CURRENT_PROJECT_VERSION: $NEXT/" project.yml
echo "🔢 ビルド番号: $CURRENT → $NEXT"

# 1. XcodeGen再生成
echo "📦 プロジェクト再生成..."
~/bin/xcodegen generate

# 2. Archive
echo "🔨 Archive作成中..."
xcodebuild archive \
  -project FodCare.xcodeproj \
  -scheme FodCare \
  -archivePath build/FodCare.xcarchive \
  -configuration Release \
  -allowProvisioningUpdates \
  DEVELOPMENT_TEAM=XL5369X7NP \
  CODE_SIGN_STYLE=Automatic

# 3. IPA作成
DATE=$(date "+%Y-%m-%d %H-%M-%S")
DEST="$HOME/Downloads/FodCare ${DATE}"

echo "📱 IPA作成中..."
xcodebuild -exportArchive \
  -archivePath build/FodCare.xcarchive \
  -exportPath "$DEST" \
  -exportOptionsPlist configs/ExportOptions.plist \
  -allowProvisioningUpdates

echo ""
echo "✅ 完了！"
echo "📂 出力先: $DEST"
echo ""

# 4. 結果を開く
if [ -d "$DEST" ]; then
  open "$DEST"
fi
open build/FodCare.xcarchive

echo "次のステップ:"
echo "  App Store Connect → TestFlight でテスターを追加"
