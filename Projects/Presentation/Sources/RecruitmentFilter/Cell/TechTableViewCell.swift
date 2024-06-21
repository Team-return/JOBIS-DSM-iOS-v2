import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class TechStackViewCell: BaseView {
    public var code: CodeEntity?
    public var techCheckBoxDidTap: ((CodeEntity?) -> Void)?
    public var isCheck: Bool = false {
        didSet {
            techCheckBoxDidTap?(code)
            techCheckBox.isCheck = isCheck
        }
    }
    private let backStackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 12, left: 24, bottom: 12, right: 24)
    }
    private let techCheckBox = JobisCheckBox()
    private let techLabel = UILabel()
    private var disposeBag = DisposeBag()

    override func addView() {
        self.addSubview(backStackView)
        [
            techCheckBox,
            techLabel
        ].forEach(self.backStackView.addArrangedSubview(_:))
    }

    override func setLayout() {
        techCheckBox.snp.makeConstraints {
            $0.width.height.equalTo(28)
        }
        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureView() {
        techCheckBox.rx.tap.asObservable()
            .bind { [weak self] in
                self?.isCheck.toggle()
            }
            .disposed(by: disposeBag)
    }

    func adapt(model: CodeEntity) {
        self.code = model
        self.techLabel.setJobisText(model.keyword, font: .body, color: .GrayScale.gray70)
    }
}
