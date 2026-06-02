#!/bin/bash
#
# JOBIS iOS pre-commit 훅 설치 스크립트
# 프로젝트 루트에서 실행: ./scripts/setup-hooks.sh
#

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$REPO_ROOT/.git/hooks"
SOURCE_DIR="$REPO_ROOT/scripts/hooks"

echo "🔧 pre-commit 훅 설치 중..."

# pre-commit 훅 심볼릭 링크 생성
ln -sf "$SOURCE_DIR/pre-commit" "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

echo "✅ pre-commit 훅 설치 완료"
echo "   위치: $HOOKS_DIR/pre-commit → $SOURCE_DIR/pre-commit"
echo ""
echo "SwiftLint가 없다면: brew install swiftlint"
