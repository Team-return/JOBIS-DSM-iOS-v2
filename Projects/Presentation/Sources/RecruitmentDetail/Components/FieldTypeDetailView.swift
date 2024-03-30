import UIKit
import SnapKit
import Then
import Domain
import DesignSystem
import RxSwift

final class FieldTypeDetailView: BaseView {
    public var interviewReviewID: Int?
    public var isOpen = false {
        didSet {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: .transitionCrossDissolve
            ) { [self] in
                detailView.arrangedSubviews.forEach { $0.isHidden = !isOpen }
                detailView.arrangedSubviews.forEach { $0.alpha = isOpen ? 1 : 0 }
                fieldTypeArrowImageView.image = .jobisIcon(isOpen ? .arrowUp : .arrowDown)
                self.layoutIfNeeded()
            }
        }
    }
    private let disposeBag = DisposeBag()
    private let backStackView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let titleView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let fieldTypeLabel = UILabel().then {
        $0.setJobisText(
            "프론트엔드/백엔드",
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
    }
    private let fieldTypeArrowImageView = UIImageView().then {
        $0.image = .jobisIcon(.arrowDown)
    }
    private let detailView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    private let majorTaskMenuLabel = UILabel().then {
        $0.setJobisText(
            "주요 업무",
            font: .description,
            color: .GrayScale.gray60
        )
        $0.isHidden = true
    }
    private let majorTaskLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    private let useSkillsMenuLabel = UILabel().then {
        $0.setJobisText(
            "사용 기술",
            font: .description,
            color: .GrayScale.gray60
        )
        $0.isHidden = true
    }
    private let useSkillsLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    private let preferElemnetMenuLabel = UILabel().then {
        $0.setJobisText(
            "우대사항",
            font: .description,
            color: .GrayScale.gray60
        )
        $0.isHidden = true
    }
    private let preferElemnetLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
        $0.isHidden = true
    }

    override func addView() {
        self.addSubview(backStackView)

        [
            titleView,
            detailView
        ].forEach(self.backStackView.addSubview(_:))

        [
            fieldTypeLabel,
            fieldTypeArrowImageView
        ].forEach(self.titleView.addArrangedSubview(_:))

        [
            majorTaskMenuLabel,
            majorTaskLabel,
            useSkillsMenuLabel,
            useSkillsLabel,
            preferElemnetMenuLabel,
            preferElemnetLabel
        ].forEach(self.detailView.addArrangedSubview(_:))
    }

    override func setLayout() {
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        detailView.snp.updateConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(isOpen ? 16 : 0)
        }

        fieldTypeArrowImageView.snp.makeConstraints {
            $0.width.equalTo(24)
        }

        [
            majorTaskMenuLabel,
            useSkillsMenuLabel,
            preferElemnetMenuLabel
        ].forEach { detailView.setCustomSpacing(4, after: $0) }

        [
            majorTaskLabel,
            useSkillsLabel,
            preferElemnetLabel
        ].forEach { detailView.setCustomSpacing(16, after: $0)}

        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureView(model: AreaEntity) {
        super.configureView()
        fieldTypeLabel.text = model.job
        majorTaskLabel.text = model.majorTask == "" ? "-" : model.majorTask
        useSkillsLabel.text = model.tech.joined(separator: ", ") == "" ? "-"
        : model.tech.joined(separator: ", ")
        preferElemnetLabel.text = model.preferentialTreatment == "" ? "-"
        : model.preferentialTreatment ?? "-"
        self.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.isOpen.toggle()
            }
            .disposed(by: disposeBag)
    }
}
