#!/bin/bash
#
# Claude Code PostToolUse hook: SwiftLint on Save
# Edit/Write 툴 사용 후 수정된 Swift 파일에 SwiftLint를 즉시 실행한다.
# Claude가 결과를 보고 바로 수정할 수 있도록 stdout으로 출력.
#

SWIFTLINT=$(which swiftlint 2>/dev/null || echo "")

if [ -z "$SWIFTLINT" ]; then
    exit 0  # SwiftLint 없으면 조용히 통과
fi

# Claude Code가 훅에 파일 경로를 환경변수 또는 stdin JSON으로 전달
# stdin에서 file_path 추출
INPUT=$(cat /dev/stdin 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input', {}).get('file_path', ''))" 2>/dev/null || echo "")

# .swift 파일이 아니면 종료
if [[ "$FILE_PATH" != *.swift ]]; then
    exit 0
fi

# 파일이 존재하는지 확인
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# SwiftLint 실행
RESULT=$("$SWIFTLINT" lint --quiet "$FILE_PATH" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ] && [ -n "$RESULT" ]; then
    echo "SwiftLint 경고/오류:"
    echo "$RESULT"
fi

exit 0  # 훅 자체는 항상 성공 (차단하지 않음 — 에이전트가 판단)
