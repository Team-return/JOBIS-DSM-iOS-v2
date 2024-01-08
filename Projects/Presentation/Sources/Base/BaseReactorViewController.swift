import UIKit
import RxCocoa
import RxSwift
import DesignSystem

public class BaseReactorViewController<Reactor: BaseReactor>: UIViewController,
                                                           ViewControllable,
                                                           LifeCyclePublishable,
                                                           HasDisposeBag,
                                                           AddViewable,
                                                           SetLayoutable,
                                                           ViewControllerConfigurable,
                                                           NavigationConfigurable {
    public let reactor: Reactor
    public var disposeBag = DisposeBag()
    public var viewDidLoadPublisher = PublishRelay<Void>()
    public var viewWillAppearPublisher = PublishRelay<Void>()
    public var viewDidAppearPublisher = PublishRelay<Void>()
    public var viewWillDisappearPublisher = PublishRelay<Void>()
    public var viewDidDisappearPublisher = PublishRelay<Void>()

    public init(_ reactor: Reactor) {
        self.reactor = reactor
        super .init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addView()
        setLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .GrayScale.gray10

        bindAction(self.reactor)
        bindState(self.reactor)
        configureViewController()
        configureNavigation()

        viewDidLoadPublisher.accept(())
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearPublisher.accept(())
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppearPublisher.accept(())
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewWillDisappearPublisher.accept(())
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewDidDisappearPublisher.accept(())
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    public func addView() {}

    public func setLayout() {}

    public func bindAction(_ reactor: Reactor) {}

    public func bindState(_ reactor: Reactor) {}

    public func configureViewController() {}

    public func configureNavigation() {}
}
