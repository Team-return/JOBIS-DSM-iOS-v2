import UIKit
import RxCocoa
import RxSwift
import DesignSystem

open class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
    public let viewModel: ViewModel
    public var disposeBag = DisposeBag()
    public let viewAppear = PublishRelay<Void>()
    let bounds = UIScreen.main.bounds

    public init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .GrayScale.gray10

        attribute()
        bind()
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAppear.accept(())
    }
    override open func viewWillLayoutSubviews() {
        addView()
        layout()
    }

    open func addView() { }

    open func layout() { }

    open func bind() { }

    open func attribute() {}

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
