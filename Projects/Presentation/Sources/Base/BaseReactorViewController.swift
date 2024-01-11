import UIKit
import RxCocoa
import RxSwift
import DesignSystem

public class BaseReactorViewController<Reactor: BaseReactor>: UIViewController,
                                                              ViewControllable,
                                                              LifeCyclePublishable,
                                                              HasDisposeBag,
                                                              AddViewable,
                                                              ReactorBindable,
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

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addView()
        setLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .GrayScale.gray10

        bindAction()
        bindState()
        configureViewController()
        configureNavigation()

        self.viewDidLoadPublisher.accept(())
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
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    public func addView() {}

    public func setLayout() {}

    public func bindAction() {}

    public func bindState() {}

    public func configureViewController() {}

    public func configureNavigation() {}
}
