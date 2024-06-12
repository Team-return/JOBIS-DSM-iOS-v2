import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class JobsCollectionViewCell: BaseCollectionViewCell<CodeEntity> {
    static let identifier = "JobsCollectionViewCell"
    public var isCheck: Bool = false {
        didSet {
            self.backgroundColor = isCheck ? .Primary.blue20 : .GrayScale.gray30
            self.jobLabel.setJobisText(
                model?.keyword ?? "",
                font: .body,
                color: isCheck ? .GrayScale.gray10 : .Primary.blue40
            )
        }
    }
    private var disposeBag = DisposeBag()
    private let jobLabel = UILabel()

    override func addView() {
        self.contentView.addSubview(jobLabel)
    }

    override func setLayout() {
        jobLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 16
    }

    override func adapt(model: CodeEntity) {
        super.adapt(model: model)
        jobLabel.setJobisText(model.keyword, font: .body, color: .Primary.blue40)
    }
}
