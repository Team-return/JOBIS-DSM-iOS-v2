import UIKit
import RxCocoa
import RxSwift
import DesignSystem

open class BaseReactorViewController<Reactor: BaseReactor>: UIViewController {
    public let reactor: Reactor
    public var disposeBag = DisposeBag()
    public let viewAppear = PublishRelay<Void>()
    let bounds = UIScreen.main.bounds

    public init(_ reactor: Reactor) {
        self.reactor = reactor
        super .init(nibName: nil, bundle: nil)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .GrayScale.gray10

        attribute()
        bind(reactor: self.reactor)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAppear.accept(())
    }

    override open func viewWillLayoutSubviews() {
        addView()
        setLayout()
    }

    open func addView() {}

    open func setLayout() {}

    open func bind(reactor: Reactor) {}

    open func attribute() {}

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
