import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ReviewTechStackViewCell: BaseView {
    public var code: CodeEntity?
    public var techCheckBoxDidTap: ((CodeEntity?) -> Void)?
    public var isCheck: Bool = false {
        didSet {
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
                guard let self = self else { return }
                self.isCheck.toggle()
                self.techCheckBoxDidTap?(self.code)
            }
            .disposed(by: disposeBag)
    }

    func adapt(model: CodeEntity) {
        self.code = model
        self.techLabel.setJobisText(model.keyword, font: .body, color: .GrayScale.gray70)
    }
}

class ReviewTechStackView: UIStackView {
    public var techDidTap: ((CodeEntity) -> Void)?
    private let disposeBag = DisposeBag()
    private var selectedCell: ReviewTechStackViewCell?

    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 0
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTech(techList: [CodeEntity]) {
        self.subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        selectedCell = nil
        techList.forEach { data in
            let techStackViewCell = ReviewTechStackViewCell()
            techStackViewCell.adapt(model: data)
            techStackViewCell.techCheckBoxDidTap = { [weak self] code in
                guard let self = self else { return }
                let tappedCell = techStackViewCell
                if self.selectedCell != tappedCell {
                    self.selectedCell?.isCheck = false
                    tappedCell.isCheck = true
                    self.selectedCell = tappedCell
                } else {
                    tappedCell.isCheck.toggle()
                    if !tappedCell.isCheck {
                        self.selectedCell = nil
                    }
                }
                if let code = code {
                    self.techDidTap?(code)
                }
            }
            self.addArrangedSubview(techStackViewCell)
        }
    }
}
