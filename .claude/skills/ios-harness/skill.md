---
name: ios-harness
description: JOBIS iOS 개발 하네스 오케스트레이터. ios-developer, ios-critic, ios-reviewer 에이전트 팀을 조율하여 피처를 개발하고 검증한다. "피처 개발해줘", "화면 만들어줘", "기능 추가해줘" 등 새 기능 구현 요청 시 반드시 사용. 단순 코드 수정이 아닌 새 Reactor/ViewController/UseCase/Repository를 포함하는 작업에 트리거.
---

## 실행 모드

**에이전트 팀 모드** — ios-developer, ios-critic, ios-reviewer가 TeamCreate로 구성된 팀에서 직접 통신(SendMessage)하며 협업한다.

## 워크플로우

### Phase 1: PRD 인터뷰 및 명세 작성

`_workspace/progress.md`는 컨텍스트 압축/재시작 이후에도 현재 상태를 복구하는 단일 진실 공급원으로 취급한다.

**시작 절차 (세션 인계 파일 로드):**

1. Phase 1 시작 전에 `_workspace/progress.md` 존재 여부를 먼저 확인한다.
2. 파일이 있으면 현재 phase, 최근 결정사항, 열린 질문, 다음 액션을 먼저 읽고 이어서 진행한다.
3. 이전 작업을 이어받는 경우 progress 내용을 기준으로 누락된 인터뷰/검증 단계만 수행한다.
4. 새로운 작업으로 전환하는 경우 기존 progress와 무관함을 사용자에게 한 줄로 알리고, 이번 작업 기준으로 `_workspace/progress.md`를 갱신한다.

자유 텍스트 요청을 그대로 사용하지 않는다. 아래 PRD 양식에 따라 사용자에게 항목별로 확인한다.

**인터뷰 절차:**

1. 사용자 요청에서 파악 가능한 항목을 먼저 채운다.
2. **누락된 필수 항목만** 사용자에게 질문한다 (이미 명확한 항목은 묻지 않는다).
3. 추정 가능한 항목은 `(추정)` 표시 후 기본값으로 채우고 사용자 확인을 구한다.

**PRD 양식:**

```markdown
# PRD: {피처명}

## 기능 설명
무엇을 하는 화면/기능인가? 사용자 관점에서 한 문단으로.

## API 명세
| 메서드 | 엔드포인트 | 요청 파라미터 | 응답 |
|--------|-----------|--------------|------|
| GET    | /example  | id: Int      | {...} |

## 네비게이션 흐름
- 진입: 어떤 화면에서 오는가?
- 이동: 이 화면에서 어디로 갈 수 있는가?
- 뒤로가기: pop? dismiss?

## 엣지케이스
- [ ] 빈 상태 (데이터 없음): 어떻게 표시하는가?
- [ ] 로딩 중: 스켈레톤? 스피너?
- [ ] 에러: 토스트? 재시도 버튼?
- [ ] 기타:

## 비고
추가 요구사항, 디자인 참고, 주의사항
```

4. 인터뷰 완료 후 `_workspace/01_spec_{feature}.md`에 PRD 저장.
5. 사용자에게 PRD 요약 보여주고 확인 받은 뒤 Phase 2 진행.
6. Phase 1 종료 시 `_workspace/progress.md`를 갱신한다.

### Phase 2: 팀 구성

```
TeamCreate(
  team_name: "ios-feature-team",
  members: ["ios-developer", "ios-critic", "ios-reviewer"]
)
```

작업 목록을 생성한다:
```
TaskCreate([
  { id: "dev",    title: "피처 코드 생성",   assignee: "ios-developer" },
  { id: "critic", title: "설계 반박 검토",   assignee: "ios-critic",   depends_on: ["dev"] },
  { id: "review", title: "패턴 검증",        assignee: "ios-reviewer", depends_on: ["critic"] }
])
```

### Phase 3: TDD 개발-반박-검증 사이클

**RED (ios-developer):**
- `_workspace/01_spec_{feature}.md`를 읽고 피처 명세 파악
- 기존 유사 코드를 읽어 패턴 파악
- **테스트 파일 먼저 작성** (`{Feature}ReactorTests.swift`, `{Feature}UseCaseTests.swift`)
  - Mock UseCase/Repository 포함
  - 아직 구현이 없으므로 컴파일 에러 상태가 정상 (RED)
- 테스트 완료 후 `_workspace/01a_tests_{feature}.md`에 테스트 케이스 목록 기록

**GREEN (ios-developer):**
- 레이어 전반 구현 코드 생성 (Reactor, VC, UseCase, Repository, Flow)
- 테스트가 통과하는 최소한의 구현에 집중
- 생성 완료 후 ios-critic에게 SendMessage로 반박 요청

**반박 (ios-critic):**
- 생성된 코드를 읽고 설계 의도/엣지케이스/대안을 의도적으로 반박
- 결과를 `_workspace/03_critic_{feature}.md`에 저장
- `CHALLENGE`: ios-developer에게 SendMessage로 반박 내용 전달 → developer가 수용 여부 결정 후 ios-reviewer에게 진행
- `ACCEPT`: ios-reviewer에게 SendMessage로 검증 요청

**검증 (ios-reviewer):**
- 구현 코드 + 테스트 코드를 모두 읽은 뒤 ios-code-review 체크리스트 적용
- **테스트 검증 추가**: 각 Action/Mutation에 대한 테스트 케이스가 존재하는지, Mock이 올바른지 확인
- 결과를 `_workspace/02_review_{feature}.md`에 저장
- `APPROVED` → REFACTOR 단계 진행
- `NEEDS_REVISION`: ios-developer에게 SendMessage로 수정 지침 전달

**REFACTOR (ios-developer):**
- 테스트가 통과하는 상태를 유지하면서 코드 품질 개선
- 중복 제거, 네이밍 정리, 불필요한 주석 삭제
- `mutate()` / `reduce()` 내 복잡한 로직 분리 (private 메서드 추출)
- 리팩토링 후 테스트가 여전히 통과하는지 확인
- 완료 후 ios-reviewer에게 최종 검토 요청

**반복:**
- ios-developer가 피드백 반영 후 재검증 요청
- 최대 3회 반복 → 3회 후에도 Critical 이슈 존재 시 오케스트레이터에게 에스컬레이션

### Phase 4: 완료 및 정리

- `_workspace/` 내 중간 파일 보존 (감사 추적용)
- `_workspace/progress.md`를 최종 상태로 갱신 (`done`, 생성 파일, 남은 후속 작업 유무)
- 최종 생성 파일 목록을 사용자에게 보고
- 팀 정리

## 세션 인계 파일 규칙

- 경로: `_workspace/progress.md`
- 목적: 컨텍스트 압축/재시작 후에도 현재 진행 상황을 즉시 복구
- 소유자: 오케스트레이터가 읽기/쓰기 책임을 가진다. 에이전트는 progress 변경이 필요하면 SendMessage로 상태 변경을 보고한다.
- 갱신 시점: PRD 확정 직후, 테스트 케이스 작성 직후, critic/reviewer 결과 수신 직후, 최종 완료 직후
- 최소 기록 항목:
  - `current_phase`
  - `feature`
  - `completed`
  - `next_action`
  - `open_questions`
  - `artifacts`

예시:

```markdown
# Progress

- current_phase: review_requested
- feature: BookmarkList
- completed:
  - `_workspace/01_spec_bookmark-list.md` 작성
  - `_workspace/01a_tests_bookmark-list.md` 작성
  - GREEN 구현 완료
- next_action: ios-reviewer 검증 대기
- open_questions:
  - 없음
- artifacts:
  - `_workspace/01_spec_bookmark-list.md`
  - `_workspace/01a_tests_bookmark-list.md`
  - `_workspace/03_critic_bookmark-list.md`
```

## 파일 소유권 (One file, one owner)

멀티에이전트 충돌 방지를 위해 에이전트별 파일 쓰기 권한을 명시한다.

| 에이전트 | 쓰기 가능 | 읽기 전용 |
|----------|-----------|-----------|
| ios-developer | `Projects/` Swift 소스 전체, `_workspace/01_*.md` | — |
| ios-critic | `_workspace/03_critic_*.md` | `Projects/` 전체, `_workspace/01_*.md` |
| ios-reviewer | `_workspace/02_review_*.md` | `Projects/` 전체, `_workspace/01_*.md`, `_workspace/03_*.md` |

**원칙**: `Projects/` 내 Swift 파일은 ios-developer만 수정한다. critic/reviewer는 절대 소스 파일을 직접 수정하지 않는다.
`_workspace/progress.md`는 에이전트 파일 소유권 대상이 아니며, 오케스트레이터만 갱신한다.

## 데이터 전달 프로토콜

| 데이터 | 전달 방식 | 경로 |
|--------|---------|------|
| 피처 명세 | 파일 | `_workspace/01_spec_{feature}.md` |
| 진행 상태 | 파일 | `_workspace/progress.md` |
| 생성 코드 | 직접 작성 | `Projects/{Layer}/Sources/{Feature}/` |
| 반박 결과 | 파일 + SendMessage | `_workspace/03_critic_{feature}.md` |
| 리뷰 결과 | 파일 + SendMessage | `_workspace/02_review_{feature}.md` |
| 수정 지침 | SendMessage | ios-reviewer/critic → ios-developer |
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
2. 오케스트레이터가 `_workspace/progress.md` 확인 후 PRD 인터뷰 진행, `_workspace/01_spec_bookmark-list.md` 작성
3. ios-developer가 RED 단계에서 테스트 파일과 `_workspace/01a_tests_bookmark-list.md` 작성
4. ios-developer가 GREEN 단계에서 BookmarkListReactor, BookmarkListViewController, BookmarkUseCase, BookmarkRepository 생성
5. ios-critic이 설계 반박 수행 후 ACCEPT 또는 경미한 CHALLENGE 전달
6. ios-reviewer가 테스트/패턴 검증 후 APPROVED
7. ios-developer가 REFACTOR 후 테스트 재확인, `_workspace/progress.md`를 `done`으로 갱신
8. 사용자에게 생성 파일 목록과 검증 결과 보고

### 에러 흐름
1. ios-critic이 CHALLENGE (중복 요청 처리 누락, State 과도 설계) 전달
2. ios-developer가 구조를 단순화하고 progress를 `critic_resolved`로 갱신
3. ios-reviewer가 NEEDS_REVISION (Reactor의 reduce()에서 side effect 발견)
4. ios-developer가 `mutate()`로 이동하고 테스트 보강 후 재제출
5. ios-reviewer APPROVED, ios-developer가 REFACTOR 및 최종 progress 갱신

### 세션 복구 흐름
1. 컨텍스트 압축 또는 세션 재시작 발생
2. 오케스트레이터가 `_workspace/progress.md`를 읽고 마지막 phase와 artifact를 복구
3. 누락된 단계만 이어서 수행하고 중복 인터뷰/중복 리뷰는 생략
