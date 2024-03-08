import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class NoticeTableViewCell: BaseTableViewCell<RecruitmentEntity> {
    static let identifier = "NoticeTableViewCell"

    public var noticeID = 0
    private var disposeBag = DisposeBag()
    private let noticeTitleLabel = UILabel().then {
        $0.setJobisText(
            "[중요] 오리엔테이션날 일정 안내",
            font: .body,
            color: UIColor.GrayScale.gray90
        )
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    private let noticeDateLabel = UILabel().then {
        $0.setJobisText("2024.01.17", font: .description, color: .GrayScale.gray60)
    }
    private let navigationArrowImageView = UIImageView().then {
        $0.image = .jobisIcon(.arrowNavigate)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    override func addView() {
        [
            noticeTitleLabel,
            noticeDateLabel,
            navigationArrowImageView
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        noticeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(24)
        }
        noticeDateLabel.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(24)
        }
        navigationArrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
        }
    }

    override func configureView() { }

    override func adapt(model: RecruitmentEntity) { }
}
