import UIKit

public class BaseView: UIView,
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

    public func addView() {}

    public func setLayout() {}

    public func configureView() {}
}
