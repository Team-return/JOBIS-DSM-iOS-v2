import UIKit
import RxCocoa
import RxSwift
import DesignSystem

open class BaseViewController<ViewModel: BaseViewModel>: UIViewController,
                                                         ViewControllable,
                                                         LifeCyclePublishable,
                                                         HasDisposeBag,
                                                         AddViewable,
                                                         SetLayoutable,
                                                         Bindable,
                                                         ViewControllerConfigurable,
                                                         NavigationConfigurable {
    public let viewModel: ViewModel
    public var disposeBag = DisposeBag()
    public var viewDidLoadPublisher = PublishRelay<Void>()
    public var viewWillAppearPublisher = PublishRelay<Void>()
    public var viewDidAppearPublisher = PublishRelay<Void>()
    public var viewWillDisappearPublisher = PublishRelay<Void>()
    public var viewDidDisappearPublisher = PublishRelay<Void>()

    public init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .GrayScale.gray10

        addView()
        setLayout()
        bind()
        configureViewController()
        configureNavigation()

        viewDidLoadPublisher.accept(())
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearPublisher.accept(())
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppearPublisher.accept(())
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewWillDisappearPublisher.accept(())
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewDidDisappearPublisher.accept(())
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    open func addView() {}

    open func setLayout() {}

    open func bind() {}

    open func configureViewController() {}

    open func configureNavigation() {}
}
