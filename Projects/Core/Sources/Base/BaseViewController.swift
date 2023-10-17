import UIKit
import RxCocoa
import RxSwift

open class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
    public let viewModel: ViewModel
    public var disposeBag = DisposeBag()
    let bounds = UIScreen.main.bounds

    public init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        addView()
        layout()
        attribute()
        bind()
    }

    open func addView() { }

    open func layout() { }

    open func bind() { }

    open func attribute() {}

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
