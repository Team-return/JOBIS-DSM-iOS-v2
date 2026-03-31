---
name: ios-harness
description: JOBIS iOS 개발 하네스 오케스트레이터. ios-developer와 ios-reviewer 에이전트 팀을 조율하여 피처를 개발하고 검증한다. "피처 개발해줘", "화면 만들어줘", "기능 추가해줘" 등 새 기능 구현 요청 시 반드시 사용. 단순 코드 수정이 아닌 새 Reactor/ViewController/UseCase/Repository를 포함하는 작업에 트리거.
---

## 실행 모드

**에이전트 팀 모드** — ios-developer와 ios-reviewer가 TeamCreate로 구성된 팀에서 직접 통신(SendMessage)하며 협업한다.

## 워크플로우

### Phase 1: 준비

피처 명세를 확인하고 작업 범위를 정의한다.

1. 사용자 요청에서 다음을 파악한다:
   - 피처 이름 및 기능 설명
   - 관련 API 명세 (있으면)
   - 네비게이션 흐름
   - 연관된 기존 모듈

2. `_workspace/` 디렉토리를 생성하고 피처 명세를 파일로 저장한다:
   ```
   _workspace/01_spec_{feature}.md
   ```

### Phase 2: 팀 구성

```
TeamCreate(
  team_name: "ios-feature-team",
  members: ["ios-developer", "ios-reviewer"]
)
```

작업 목록을 생성한다:
```
TaskCreate([
  { id: "dev", title: "피처 코드 생성", assignee: "ios-developer" },
  { id: "review", title: "코드 검증", assignee: "ios-reviewer", depends_on: ["dev"] }
])
```

### Phase 3: 개발-검증 사이클

**개발 (ios-developer):**
- `_workspace/01_spec_{feature}.md`를 읽고 피처 명세 파악
- 기존 유사 코드를 읽어 패턴 파악
- 레이어 전반 코드 생성 (Reactor, VC, UseCase, Repository, Flow)
- 생성 완료 후 ios-reviewer에게 SendMessage로 리뷰 요청

**검증 (ios-reviewer):**
- 생성된 코드를 모두 읽은 뒤 ios-code-review 체크리스트 적용
- 결과를 `_workspace/02_review_{feature}.md`에 저장
- `APPROVED`: 오케스트레이터에게 완료 보고
- `NEEDS_REVISION`: ios-developer에게 SendMessage로 수정 지침 전달

**반복:**
- ios-developer가 피드백 반영 후 재검증 요청
- 최대 3회 반복 → 3회 후에도 Critical 이슈 존재 시 오케스트레이터에게 에스컬레이션

### Phase 4: 완료 및 정리

- `_workspace/` 내 중간 파일 보존 (감사 추적용)
- 최종 생성 파일 목록을 사용자에게 보고
- 팀 정리

## 데이터 전달 프로토콜

| 데이터 | 전달 방식 | 경로 |
|--------|---------|------|
| 피처 명세 | 파일 | `_workspace/01_spec_{feature}.md` |
| 생성 코드 | 직접 작성 | `Projects/{Layer}/Sources/{Feature}/` |
| 리뷰 결과 | 파일 + SendMessage | `_workspace/02_review_{feature}.md` |
| 수정 지침 | SendMessage | ios-reviewer → ios-developer |
| 최종 보고 | 텍스트 | 사용자에게 직접 |

## 에러 핸들링

| 상황 | 처리 방법 |
|------|---------|
| 피처 명세 불완전 | 개발 시작 전 사용자에게 명확화 요청 |
| 3회 반복 후 Critical 이슈 잔존 | 오케스트레이터가 직접 개입, 근본 원인 분석 |
| 기존 파일과 충돌 | ios-developer가 기존 코드 읽기 후 판단, 필요시 오케스트레이터 승인 |
| 에이전트 응답 없음 | 1회 재시도 후 실패 시 해당 Phase 건너뛰고 보고서에 명시 |

## 테스트 시나리오

### 정상 흐름
1. 사용자: "북마크 목록 화면 만들어줘 (GET /bookmarks API)"
2. 오케스트레이터가 명세 파일 작성 후 팀 구성
3. ios-developer: BookmarkListReactor, BookmarkListViewController, BookmarkUseCase, BookmarkRepository 생성
4. ios-reviewer: 검증 후 APPROVED
5. 사용자에게 생성 파일 목록 보고

### 에러 흐름
1. ios-reviewer가 NEEDS_REVISION (Reactor의 reduce()에서 네트워크 호출 발견)
2. ios-developer가 mutate()로 이동 후 재제출
3. ios-reviewer APPROVED
4. 완료 보고
