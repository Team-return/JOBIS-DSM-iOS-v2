---
name: ios-code-review
description: JOBIS iOS 코드 검증 스킬. ios-developer가 생성한 코드를 프로젝트 표준에 따라 검증. ReactorKit, Clean Architecture, RxFlow, Swinject 기준 검증 시 반드시 사용. 코드 리뷰, 아키텍처 검증, 패턴 준수 확인 요청 시 트리거. PR 리뷰, 코드 품질 확인, 레이어 경계 위반 탐지에도 사용할 것.
---

## 검증 실행 방법

검증 대상 파일을 전부 읽은 뒤 아래 체크리스트를 순서대로 적용한다. 파일을 읽지 않고 리뷰하지 않는다.

## 체크리스트

### [Critical] 아키텍처 경계

```
□ Presentation이 Data 레이어를 직접 import하지 않는가?
□ Domain이 Presentation/Data를 import하지 않는가?
□ UseCase가 ViewController/Reactor를 참조하지 않는가?
□ Repository protocol이 Domain에 위치하는가?
□ Repository 구현체가 Data에 위치하는가?
```

위반 시 → Critical 이슈로 보고. 아키텍처 위반은 수정 없이 통과 불가.

### [Critical] ReactorKit 패턴

```
□ mutate(): Observable<Mutation> 반환, side effect(네트워크/저장/알림) 처리
□ reduce(): 순수 함수, Observable/async 사용 없음, side effect 없음
□ State: 값 타입(struct), 변경은 reduce()를 통해서만
□ Action/Mutation/State: Reactor 내부에 선언
□ initialState: 올바른 초기값 설정
```

### [High] RxSwift 메모리 관리

```
□ DisposeBag: ViewController의 인스턴스 변수 (var/let disposeBag = DisposeBag())
□ bind(reactor:)에서 모든 구독 처리
□ 클로저 내 [weak self] 캡처 (순환 참조 방지)
□ share(), replay() 불필요한 중복 없음
□ Subject(PublishSubject 등) 직접 노출 없음 (Observable로 변환 후 노출)
```

### [High] Swinject DI

```
□ 모든 의존성이 init() 파라미터로 주입 (프로퍼티 직접 설정 금지)
□ Assembly에 등록되어 있는가? (미등록 시 런타임 크래시)
□ 순환 의존성 없는가? (A→B→A 형태)
□ Singleton 범위가 적절한가? (Repository/UseCase: .container, Reactor: .transient)
```

### [High] RxFlow

```
□ Step 이름이 화면 의도를 명확히 표현하는가? (e.g., companyDetailIsRequired(id:))
□ Flow.navigate(to:)에서 모든 Step case를 처리하는가? (switch 누락 없음)
□ FlowContributors 반환값이 올바른가? (.one/.multiple/.none)
□ Stepper에서 steps.accept() 호출 위치가 적절한가?
```

### [Medium] UI/Layout

```
□ setupUI() → setLayout() → bind() 순서인가?
□ SnapKit: snp.makeConstraints 사용, 중복 constraints 없음
□ Then: 클로저 내 불필요한 self 참조 없음
□ viewDidLoad에서 bind(reactor:) 직접 호출하지 않음 (reactor 프로퍼티 설정으로 자동 호출)
□ Cell 재사용 준비: prepareForReuse()에서 구독 해제
```

### [Medium] 네이밍 컨벤션

```
□ 파일명 = 클래스명 일치
□ UseCase: 프로토콜 = {Feature}UseCase, 구현체 = Default{Feature}UseCase
□ Repository: 프로토콜 = {Feature}Repository, 구현체 = {Feature}RepositoryImpl
□ Reactor: {Feature}Reactor
□ ViewController: {Feature}ViewController
□ Step case: 현재형+수동태 (e.g., listIsRequired, detailIsRequired(id:))
```

## 출력 형식

검증 결과를 반드시 다음 구조로 출력한다:

```
## 검증 결과

**상태**: APPROVED / NEEDS_REVISION

### Critical 이슈
(없으면 "없음")
- [{파일명}:{라인}] {이슈 설명}
  수정: {구체적인 수정 방법}

### High 이슈
(없으면 "없음")
- [{파일명}:{라인}] {이슈 설명}
  수정: {구체적인 수정 방법}

### Medium 이슈
(없으면 "없음")
- [{파일명}:{라인}] {이슈 설명}
  수정: {구체적인 수정 방법}

### 제안 (수정 강제 아님)
- {개선 가능한 사항}
```

## APPROVED 조건

- Critical 이슈 0개
- High 이슈 0개
- Medium 이슈는 있어도 APPROVED 가능 (개발자 판단)

## 판단 기준 모호 시

`Projects/Presentation/Sources/` 내 기존 Reactor/ViewController 파일을 직접 읽어 프로젝트 실제 패턴을 기준으로 판단한다. 문서보다 코드가 우선이다.
