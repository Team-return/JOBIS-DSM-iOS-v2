import UIKit
import SnapKit
import Then
import Domain
import DesignSystem
import RxSwift

final class FieldTypeDetailViewCell: BaseTableViewCell<AreaEntity> {
    static let identifier = "FieldTypeDetailViewCell"
    public var interviewReviewID: Int?
    public var isOpen = false {
        didSet {
            detailView.isHidden = !isOpen
            detailView.alpha = isOpen ? 1 : 0
            fieldTypeArrowImageView.image = .jobisIcon(isOpen ? .arrowUp : .arrowDown)
        }
    }
    private let disposeBag = DisposeBag()
    private let backStackView = UIStackView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.spacing = 16
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
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
    private let detailView = UIView().then {
        $0.isHidden = true
        $0.alpha = 0
    }
    private let majorTaskMenuLabel = UILabel().then {
        $0.setJobisText(
            "주요 업무",
            font: .description,
            color: .GrayScale.gray60
        )
    }
    private let majorTaskLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
    }
    private let useSkillsMenuLabel = UILabel().then {
        $0.setJobisText(
            "사용 기술",
            font: .description,
            color: .GrayScale.gray60
        )
    }
    private let useSkillsLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
    }
    private let preferElemnetMenuLabel = UILabel().then {
        $0.setJobisText(
            "우대사항",
            font: .description,
            color: .GrayScale.gray60
        )
    }
    private let preferElemnetLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
    }

    override func addView() {
        contentView.addSubview(backStackView)

        [
            titleView,
            detailView
        ].forEach(self.backStackView.addArrangedSubview(_:))

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
        ].forEach(self.detailView.addSubview(_:))
    }

    override func setLayout() {
        fieldTypeArrowImageView.snp.makeConstraints {
            $0.width.equalTo(24)
        }

        majorTaskMenuLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        majorTaskLabel.snp.makeConstraints {
            $0.top.equalTo(majorTaskMenuLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }

        useSkillsMenuLabel.snp.makeConstraints {
            $0.top.equalTo(majorTaskLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }

        useSkillsLabel.snp.makeConstraints {
            $0.top.equalTo(useSkillsMenuLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }

        preferElemnetMenuLabel.snp.makeConstraints {
            $0.top.equalTo(useSkillsLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }

        preferElemnetLabel.snp.makeConstraints {
            $0.top.equalTo(preferElemnetMenuLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        backStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }

    override func configureView() {
        self.selectionStyle = .none
    }

    override func adapt(model: AreaEntity) {
        fieldTypeLabel.text = model.job
        majorTaskLabel.text = model.majorTask
        useSkillsLabel.text = model.tech.joined(separator: ", ")
        preferElemnetLabel.text = model.preferentialTreatment
    }
}
