import UIKit
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class YearSelectionCell: UIView {
    public var year: String?
    public var yearCheckBoxDidTap: ((String?) -> Void)?
    public var isCheck: Bool = false {
        didSet {
            yearCheckBox.isCheck = isCheck
        }
    }

    private let backStackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 12, left: 24, bottom: 12, right: 24)
    }
    private let yearCheckBox = JobisCheckBox()
    private let yearLabel = UILabel()
    private var disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(backStackView)
        [
            yearCheckBox,
            yearLabel
        ].forEach { backStackView.addArrangedSubview($0) }

        yearCheckBox.snp.makeConstraints {
            $0.width.height.equalTo(28)
        }
        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        yearCheckBox.rx.tap.asObservable()
            .bind { [weak self] in
                guard let self = self else { return }
                self.isCheck.toggle()
                self.yearCheckBoxDidTap?(self.year)
            }
            .disposed(by: disposeBag)
    }

    func setYear(_ year: String) {
        self.year = year
        yearLabel.setJobisText(year, font: .body, color: .GrayScale.gray70)
    }
}

class YearSelectionView: UIStackView {
    private let disposeBag = DisposeBag()
    private var selectedCell: YearSelectionCell?
    private let selectedYearRelay = PublishRelay<String>()

    var selectedYearObservable: Observable<String> {
        return selectedYearRelay.asObservable()
    }

    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 0
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setYears(_ years: [String]) {
        self.subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        selectedCell = nil

        years.forEach { year in
            let yearCell = YearSelectionCell()
            yearCell.setYear(year)
            yearCell.yearCheckBoxDidTap = { [weak self] selectedYear in
                guard let self = self else { return }
                let tappedCell = yearCell
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
                if let year = selectedYear, tappedCell.isCheck {
                    self.selectedYearRelay.accept(year)
                }
            }
            self.addArrangedSubview(yearCell)
        }
    }
}
