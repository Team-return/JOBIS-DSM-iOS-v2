# Pre-commit Hook 가이드

## 설치

```bash
./scripts/setup-hooks.sh
```

심볼릭 링크로 `.git/hooks/pre-commit → scripts/hooks/pre-commit` 연결.

## 동작 방식

커밋 시 staged된 `.swift` 파일에 대해 SwiftLint를 실행한다.

- 위반 없음 → 커밋 진행
- 위반 있음 → 커밋 차단 + 위반 내용 출력

## SwiftLint 설치

```bash
brew install swiftlint
```

## 자동 수정

```bash
swiftlint --fix
```

자동 수정 후 다시 `git add` → `git commit`.

## 훅 임시 우회 (비상시만)

```bash
git commit --no-verify -m "메시지"
```

남용 금지. 반드시 이후 커밋에서 lint 위반을 해소해야 함.

## SwiftLint 설정

프로젝트 루트 `.swiftlint.yml` 참조.
주요 excluded: `.build/`, `Tuist/`, `Projects/App/Resources/`
