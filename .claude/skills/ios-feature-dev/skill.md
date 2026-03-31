---
name: ios-feature-dev
description: JOBIS iOS 피처 개발 스킬. ReactorKit + Clean Architecture + RxFlow + Swinject 패턴으로 새 화면/기능을 구현할 때 반드시 사용. 새 Reactor, ViewController, UseCase, Repository, Flow를 만들거나 기존 피처를 수정하는 모든 작업에 트리거. iOS 코드 작성, 화면 추가, API 연동, 네비게이션 구현 요청 시 이 스킬을 사용할 것.
---

## 코드 생성 전 준비

기존 유사 피처 코드를 반드시 먼저 읽어라. 패턴을 직접 확인하지 않고 생성하면 불일치가 발생한다.

참고할 기존 파일 위치:
- Reactor 패턴: `Projects/Presentation/Sources/` 내 임의의 `*Reactor.swift`
- ViewController 패턴: `Projects/Presentation/Sources/` 내 임의의 `*ViewController.swift`
- UseCase 패턴: `Projects/Domain/Sources/` 내 임의의 `*UseCase.swift`
- Repository 패턴: `Projects/Data/Sources/` 내 임의의 `*Repository.swift`
- Flow/Step 패턴: `Projects/Flow/Sources/` 내 기존 파일

## Reactor 작성 패턴

```swift
import ReactorKit
import RxSwift

final class {Feature}Reactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case tapButton(id: String)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setData([{Feature}Entity])
        case setError(String)
    }
    
    struct State {
        var isLoading: Bool = false
        var data: [{Feature}Entity] = []
        var errorMessage: String? = nil
    }
    
    let initialState = State()
    private let {feature}UseCase: {Feature}UseCase
    
    init({feature}UseCase: {Feature}UseCase) {
        self.{feature}UseCase = {feature}UseCase
    }
    
    // side effect 처리 — Observable<Mutation> 반환
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.concat([
                .just(.setLoading(true)),
                {feature}UseCase.fetch()
                    .map { Mutation.setData($0) }
                    .catch { .just(.setError($0.localizedDescription)) },
                .just(.setLoading(false))
            ])
        case let .tapButton(id):
            // 네비게이션은 여기서 처리하지 않음 — ViewController에서 처리
            return .empty()
        }
    }
    
    // 순수 함수 — side effect 없음, Observable 사용 금지
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setData(data):
            newState.data = data
        case let .setError(message):
            newState.errorMessage = message
        }
        return newState
    }
}
```

## ViewController 작성 패턴

```swift
import UIKit
import ReactorKit
import RxSwift
import SnapKit
import Then

final class {Feature}ViewController: UIViewController, View {
    
    // MARK: - UI Components
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register({Feature}Cell.self, forCellReuseIdentifier: {Feature}Cell.reuseIdentifier)
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(reactor: {Feature}Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setLayout()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    // bind(reactor:)는 reactor 프로퍼티 설정 시 자동 호출됨
    func bind(reactor: {Feature}Reactor) {
        // Action 바인딩
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State 바인딩
        reactor.state.map { $0.data }
            .bind(to: tableView.rx.items(
                cellIdentifier: {Feature}Cell.reuseIdentifier,
                cellType: {Feature}Cell.self
            )) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: /* 로딩 인디케이터 */)
            .disposed(by: disposeBag)
    }
}
```

## UseCase 작성 패턴

```swift
// Protocol은 Domain 레이어에 위치
protocol {Feature}UseCase {
    func fetch() -> Observable<[{Feature}Entity]>
    func execute(id: String) -> Observable<Void>
}

// 구현체도 Domain 레이어에 위치 (Data 레이어에 두지 말 것)
final class Default{Feature}UseCase: {Feature}UseCase {
    
    private let repository: {Feature}Repository
    
    init(repository: {Feature}Repository) {
        self.repository = repository
    }
    
    func fetch() -> Observable<[{Feature}Entity]> {
        repository.fetch()
    }
}
```

## Repository 작성 패턴

```swift
// Protocol은 Domain 레이어에 위치
protocol {Feature}Repository {
    func fetch() -> Observable<[{Feature}Entity]>
}

// 구현체는 Data 레이어에 위치
final class {Feature}RepositoryImpl: {Feature}Repository {
    
    private let dataSource: {Feature}DataSource
    
    init(dataSource: {Feature}DataSource) {
        self.dataSource = dataSource
    }
    
    func fetch() -> Observable<[{Feature}Entity]> {
        dataSource.fetch()
            .map { $0.map { $0.toDomain() } }  // DTO → Entity 변환
    }
}
```

## Flow/Step 패턴

```swift
// Step 정의 — 화면 의도가 명확한 이름 사용
enum {Feature}Step: Step {
    case {feature}IsRequired               // 피처 첫 진입
    case {feature}DetailIsRequired(id: String)  // 상세 화면
    case popIsRequired                     // 뒤로 가기
}

// Flow 정의
final class {Feature}Flow: Flow {
    var root: Presentable { rootViewController }
    private let rootViewController = UINavigationController()
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? {Feature}Step else { return .none }
        switch step {
        case .{feature}IsRequired:
            return navigateTo{Feature}()
        case let .{feature}DetailIsRequired(id):
            return navigateTo{Feature}Detail(id: id)
        case .popIsRequired:
            rootViewController.popViewController(animated: true)
            return .none
        }
    }
    
    private func navigateTo{Feature}() -> FlowContributors {
        let reactor = container.resolve({Feature}Reactor.self)!
        let vc = {Feature}ViewController(reactor: reactor)
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: vc,
            withNextStepper: reactor
        ))
    }
}
```

## Swinject Assembly 등록

```swift
// {Feature}Assembly.swift — Data 또는 Presentation 어셈블리에 추가
final class {Feature}Assembly: Assembly {
    func assemble(container: Container) {
        // Data 레이어
        container.register({Feature}DataSource.self) { _ in
            {Feature}DataSourceImpl()
        }
        container.register({Feature}Repository.self) { r in
            {Feature}RepositoryImpl(dataSource: r.resolve({Feature}DataSource.self)!)
        }
        // Domain 레이어
        container.register({Feature}UseCase.self) { r in
            Default{Feature}UseCase(repository: r.resolve({Feature}Repository.self)!)
        }
        // Presentation 레이어
        container.register({Feature}Reactor.self) { r in
            {Feature}Reactor({feature}UseCase: r.resolve({Feature}UseCase.self)!)
        }
    }
}
```

## 주의 사항

- `reduce()`에서 네트워크 호출, 타이머, 알림 등 side effect를 절대 사용하지 않는다
- `bind(reactor:)` 외부에서 `.subscribe()` 직접 호출은 최소화한다
- `tableView.rx.modelSelected` 등의 UI 이벤트에서 직접 화면 전환하지 않고, Reactor Action으로 전달 후 State로 처리하거나 `reactor.state.map`에서 처리한다
- 피처 간 의존성이 필요한 경우 반드시 Domain의 protocol을 통해서만 참조한다
