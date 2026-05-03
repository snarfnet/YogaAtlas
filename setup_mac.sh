#!/bin/bash
# YogaAtlas — Mac Mini セットアップスクリプト
# 実行方法: bash setup_mac.sh

set -e
echo "🧘 YogaAtlas セットアップ開始..."

# 1. xcodegen インストール確認
if ! command -v xcodegen &> /dev/null; then
    echo "📦 xcodegen をインストール中..."
    if command -v brew &> /dev/null; then
        brew install xcodegen
    else
        echo "❌ Homebrew が見つかりません。先に https://brew.sh からインストールしてください"
        exit 1
    fi
fi

# 2. Xcodeプロジェクト生成
echo "🔨 Xcodeプロジェクトを生成中..."
cd "$(dirname "$0")"
xcodegen generate

echo "✅ 完了! YogaAtlas.xcodeproj が生成されました"
echo "👉 open YogaAtlas.xcodeproj"
open YogaAtlas.xcodeproj
