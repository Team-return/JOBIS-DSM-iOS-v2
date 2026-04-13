# JOBIS iOS — Agent Guide

이 문서는 특정 모델 전용이 아니다.
Codex, Claude, 기타 코딩 에이전트가 공통으로 참조하는 루트 가이드다.

이 파일은 지도(map)다. 세부 내용은 각 링크 문서를 참조한다.

---

## 아키텍처

→ [.claude/docs/architecture.md](.claude/docs/architecture.md)

Clean Architecture + ReactorKit + RxFlow + Swinject.
레이어: `Core → Domain ← Data`, `Presentation → Domain`, `Flow → Presentation + Core`

---

## 에이전트 팀

| 에이전트 | 역할 | 문서 |
|----------|------|------|
| ios-developer | 피처 개발 (Reactor + VC + UseCase + Flow) | [→](.claude/agents/ios-developer.md) |
| ios-critic | 설계 반박, 엣지케이스 발굴, 대안 제시 | [→](.claude/agents/ios-critic.md) |
| ios-reviewer | 아키텍처·패턴 코드 리뷰 | [→](.claude/agents/ios-reviewer.md) |
| ios-gc | 미사용 import·데드코드·고아 파일 제거 | [→](.claude/agents/ios-gc.md) |

---

## 스킬

| 스킬 | 설명 |
|------|------|
| ios-harness | 피처 개발 전체 흐름 자동화 | [→](.claude/skills/ios-harness/skill.md) |
| ios-feature-dev | 피처 개발 단계별 가이드 | [→](.claude/skills/ios-feature-dev/skill.md) |
| ios-code-review | 코드 리뷰 체크리스트 | [→](.claude/skills/ios-code-review/skill.md) |

---

## 커밋 & PR 컨벤션

→ [.claude/docs/conventions.md](.claude/docs/conventions.md)

- 이슈 제목: 이모지 없음
- PR 제목: 🔗 이모지 필수
- 커밋: `이모지 :: (#이슈번호) 설명`

---

## Pre-commit Hook

→ [.claude/docs/hooks.md](.claude/docs/hooks.md)

설치: `./scripts/setup-hooks.sh`
동작: staged Swift 파일 → SwiftLint 검사 → 위반 시 커밋 차단

---

## 핵심 규칙 (반드시 숙지)

1. `Flow.rootViewController`는 `init`에서 resolve — lazy 금지 (RxFlow Coordinator가 `navigate` 이전에 `root` 접근)
2. `mutate()` 비동기 O, `reduce()` 순수 함수만
3. 레이어 역방향 import 금지
4. 모든 의존성은 Assembly를 통해 Container에 등록
