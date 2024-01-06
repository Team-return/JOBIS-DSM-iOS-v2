import UIKit

open class BaseView: UIView,
                     AddViewable,
                     SetLayoutable,
                     ViewConfigurable {
    public init() {
        super.init(frame: .zero)
        addView()
        setLayout()
        configureView()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func addView() {}

    open func setLayout() {}

    open func configureView() {}
}
