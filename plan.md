# TDD / Tidy First Plan

이 저장소에서는 앞으로 모든 작업을 아래 규칙으로 진행한다.

## Always Follow
- 항상 Red → Green → Refactor 순서를 지킨다.
- 한 번에 테스트 하나만 추가한다.
- 테스트가 실패하는 것을 확인한 뒤에만 프로덕션 코드를 수정한다.
- 테스트를 통과시키는 최소한의 코드만 작성한다.
- 구조 변경(Structural change)과 동작 변경(Behavioral change)을 같은 커밋에 섞지 않는다.
- 구조 변경이 필요하면 먼저 구조만 바꾸고 테스트로 안전성을 확인한다.
- `go` 라고 하면 아래 `Test Queue`에서 체크되지 않은 첫 번째 테스트를 수행한다.
- 각 `go` 사이클의 기본 순서는 다음과 같다.
  1. 다음 미완료 테스트 선택
  2. 테스트 작성 및 실패 확인 (Red)
  3. 최소 구현으로 테스트 통과 (Green)
  4. 필요 시 구조 개선 (Refactor / Tidy First)
  5. 관련 테스트 재실행
  6. 체크리스트 갱신

## Swift Rules
- Swift에서는 의미가 분명한 타입/메서드 이름을 우선한다.
- `mutate()` 는 비동기 가능, `reduce()` 는 순수 함수만 유지한다.
- `Flow.rootViewController` 는 `init` 에서 resolve 한다.
- 레이어 역방향 import 금지.
- 모든 의존성은 Assembly를 통해 등록한다.

## Current Structural Baseline
- [x] `CompanyDetailPreviousViewType` 를 `Presentation` 에서 제거하고 `Core/Sources/Steps` 단일 정의를 기준으로 정리한다.

## Test Queue
- [ ] 다음 기능 작업이 정해지면 첫 failing test 를 여기에 추가한다.
