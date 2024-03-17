import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

class AttachedFileTableViewCell: BaseTableViewCell<RecruitmentEntity> {
    static let identifier = "AttachedFileTableViewCell"

    private var disposeBag = DisposeBag()
    private let attachedFileButton = UIButton().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
    }
    private let attachedFileLabel = UILabel().then {
        $0.setJobisText("2024학년도 신입생 과제.hwp", font: .body, color: .GrayScale.gray90)
    }
    private let attachedFileImageView = UIImageView().then {
        $0.image = .jobisIcon(.bugBox)
    }

    override func addView() {
        contentView.addSubview(attachedFileButton)
        [
            attachedFileLabel,
            attachedFileImageView
        ].forEach {
            attachedFileButton.addSubview($0)
        }
    }

    override func setLayout() {
        attachedFileButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        attachedFileLabel.snp.makeConstraints {
            $0.centerY.equalTo(attachedFileButton)
            $0.left.equalTo(attachedFileButton.snp.left).inset(12)
        }
        attachedFileImageView.snp.makeConstraints {
            $0.centerY.equalTo(attachedFileButton)
            $0.right.equalTo(attachedFileButton.snp.right).inset(12)
            $0.height.width.equalTo(28)
        }
    }

    override func configureView() {
        self.selectionStyle = .none
    }

    override func adapt(model: RecruitmentEntity) { }
}
