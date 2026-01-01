#!/bin/bash

# GitHub Secrets 설정을 위한 모든 내용 출력 스크립트
# XCConfig 및 Firebase 설정 파일 내용을 출력

echo "========================================="
echo "GitHub Secrets 설정을 위한 파일 내용"
echo "총 4개의 Secret이 필요합니다"
echo "========================================="
echo ""

echo "=== 1. XCCONFIG_BASE64 ==="
echo "이 내용을 전체 복사하여 GitHub Secret 'XCCONFIG_BASE64'에 추가하세요"
echo "---"
tar -czf - XCConfig | base64
echo ""
echo ""

echo "=== 2. GOOGLE_SERVICE_DEV_INFO ==="
echo "이 내용을 전체 복사하여 GitHub Secret 'GOOGLE_SERVICE_DEV_INFO'에 추가하세요"
echo "---"
cat Projects/App/Resources/Firebase/GoogleService-Dev-Info.plist
echo ""
echo ""

echo "=== 3. GOOGLE_SERVICE_STAGE_INFO ==="
echo "이 내용을 전체 복사하여 GitHub Secret 'GOOGLE_SERVICE_STAGE_INFO'에 추가하세요"
echo "---"
cat Projects/App/Resources/Firebase/GoogleService-Stage-Info.plist
echo ""
echo ""

echo "=== 4. GOOGLE_SERVICE_PROD_INFO ==="
echo "이 내용을 전체 복사하여 GitHub Secret 'GOOGLE_SERVICE_PROD_INFO'에 추가하세요"
echo "---"
cat Projects/App/Resources/Firebase/GoogleService-Prod-Info.plist
echo ""
echo ""

echo "========================================="
echo "다음 단계:"
echo "1. GitHub 저장소 → Settings → Secrets and variables → Actions"
echo "2. New repository secret 클릭"
echo "3. 위 4개 내용을 각각 복사하여 추가"
echo "   - XCCONFIG_BASE64"
echo "   - GOOGLE_SERVICE_DEV_INFO"
echo "   - GOOGLE_SERVICE_STAGE_INFO"
echo "   - GOOGLE_SERVICE_PROD_INFO"
echo "========================================="
