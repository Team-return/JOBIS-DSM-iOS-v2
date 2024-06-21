import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

public final class JobisSearchTextField: UIStackView {
    private var disposeBag = DisposeBag()
    private let searchImageView = UIImageView().then {
        $0.image = .jobisIcon(.searchIcon)
    }
    private let searchTextField = UITextField()

    public init() {
        super.init(frame: .zero)
        self.spacing = 4
        self.axis = .horizontal
        self.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        self.isLayoutMarginsRelativeArrangement = true
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 12
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        addView()
        setLayout()
    }

    public func setTextField(
        placeholder: String
    ) {
        self.searchTextField.placeholder = placeholder
    }

    private func addView() {
        [
            searchImageView,
            searchTextField
        ].forEach(self.addArrangedSubview(_:))
    }

    private func setLayout() {
        searchImageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
        }
    }
}
