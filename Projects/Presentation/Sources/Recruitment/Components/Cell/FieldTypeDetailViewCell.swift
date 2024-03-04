import UIKit
import SnapKit
import Then
import Domain
import DesignSystem
import RxSwift

final class FieldTypeDetailViewCell: BaseTableViewCell<RecruitmentViewModel> {
    static let identifier = "FieldTypeDetailViewCell"

    public var interviewReviewID: Int?
    private let disposeBag = DisposeBag()
    private let containerView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let fieldTypeLabel = UILabel().then {
        $0.setJobisText(
            "프론트엔드/백엔드",
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
    }
    private let fieldTypeArrowImage = UIImageView().then {
        $0.image = .jobisIcon(.arrowDown)
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
            "프론트 짱 프론트 짱 프론트 짱 프론트 짱 프론트 짱 프론트 짱 프론트 짱 프론",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private let useTechniquesMenuLabel = UILabel().then {
        $0.setJobisText(
            "사용 기술",
            font: .description,
            color: .GrayScale.gray60
        )
    }
    private let useTechniquesLabel = UILabel().then {
        $0.setJobisText(
            "Javascript, HTML, CSS, Next.js, React",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    override func addView() {
        self.addSubview(containerView)
        [
            fieldTypeLabel,
            fieldTypeArrowImage,
            majorTaskMenuLabel,
            majorTaskLabel,
            useTechniquesMenuLabel,
            useTechniquesLabel
        ].forEach {
            containerView.addSubview($0)
        }
    }

    override func setLayout() {
        fieldTypeLabel.snp.makeConstraints {
            $0.top.equalTo(fieldTypeArrowImage.snp.top)
            $0.left.equalTo(containerView).offset(16)
        }
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        fieldTypeArrowImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().inset(16)
            $0.height.width.equalTo(24)
        }
        majorTaskMenuLabel.snp.makeConstraints {
            $0.top.equalTo(fieldTypeArrowImage.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(16)
        }
        majorTaskLabel.snp.makeConstraints {
            $0.top.equalTo(majorTaskMenuLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(16)
        }
        useTechniquesMenuLabel.snp.makeConstraints {
            $0.top.equalTo(majorTaskLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(16)
        }
        useTechniquesLabel.snp.makeConstraints {
            $0.top.equalTo(useTechniquesMenuLabel.snp.bottom).offset(4)
            $0.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    override func configureView() {
        self.selectionStyle = .none
    }

    func adapt(model: RecruitmentEntity) { }
}
