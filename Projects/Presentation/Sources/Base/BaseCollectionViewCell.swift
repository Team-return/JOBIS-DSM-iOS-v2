import UIKit

public class BaseCollectionViewCell<Model>: UICollectionViewCell,
                                     AddViewable,
                                     SetLayoutable,
                                     ViewConfigurable {
    public var model: Model?

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addView() {}

    public func setLayout() {}

    public func configureView() {}

    public func adapt(model: Model) {
        self.model = model
    }
}
