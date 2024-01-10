import UIKit

public class BaseView: UIView,
                     AddViewable,
                     SetLayoutable,
                     ViewConfigurable {
    public init() {
        super.init(frame: .zero)
        configureView()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }

    public func addView() {}

    public func setLayout() {}

    public func configureView() {}
}
