# JOBIS iOS 아키텍처

## 레이어 구조

```
Core ──────────────────────────────────────────────────────────────────┐
 └─ 공통 Base 클래스, Steps enum, 유틸리티                              │
                                                                         │
Domain ◄── Presentation        ◄── Flow                                 │
 UseCase   Reactor + VC            Flow + Step                          │
 Entity    ReactorKit 단방향 흐름   RxFlow 화면 전환                     │
 Repository protocol                                                     │
      ▲                                                                  │
Data  │                                                                  │
 RepositoryImpl                                                          │
 Moya Target (API)                                                       │
 DTO ↔ Entity 변환                                                       │
                                                                         │
App ◄── Flow ◄── Presentation ◄── Domain ◄── Data                       │
 AppDelegate       최종 조합                                             │
 DI Assembly                                                             │
└────────────────────────────────────────────────────────────────────────┘
```

## 레이어 의존성 규칙

- `Presentation → Domain` (UseCase protocol에만 의존)
- `Data → Domain` (Repository protocol 구현)
- `Flow → Presentation, Core`
- **역방향 import 절대 금지**

## 주요 패턴

### ReactorKit (단방향 흐름)
```
View ──Action──► Reactor.mutate() ──Mutation──► Reactor.reduce() ──State──► View
```

### RxFlow
- `Step`: 화면 의도를 나타내는 enum (`Core/Sources/Steps/`)
- `Flow`: Step을 받아 화면 전환 실행
- `rootViewController`는 반드시 `Flow.init`에서 resolve (lazy 금지)

### Swinject DI
- 모든 의존성: `Assembly`를 통해 `Container`에 등록
- `container.resolve(Type.self, arguments: ...)!` 패턴

## 파일 위치

| 레이어 | 경로 |
|--------|------|
| Core | `Projects/Core/Sources/` |
| Domain | `Projects/Domain/Sources/` |
| Data | `Projects/Data/Sources/` |
| Presentation | `Projects/Presentation/Sources/` |
| Flow | `Projects/Flow/Sources/` |
| App | `Projects/App/Sources/` |
