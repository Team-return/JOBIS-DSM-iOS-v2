import UIKit
import Domain
import DesignSystem
import SnapKit
import Then

final class MajorCollectionViewCell: BaseCollectionViewCell<InterestsEntity> {
    static let identifier = "MajorCollectionViewCell"

    public var isCheck: Bool = false {
        didSet {
            self.backgroundColor = isCheck ? .Primary.blue20 : .GrayScale.gray30
            self.majorLabel.setJobisText(
                model?.keyword ?? "",
                font: .body,
                color: isCheck ? .GrayScale.gray10 : .Primary.blue40
            )
        }
    }

    private let majorLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.jobisFont(.body)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    override func addView() {
        self.contentView.addSubview(majorLabel)
    }

    override func setLayout() {
        majorLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(6)
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

    override func adapt(model: InterestsEntity) {
        super.adapt(model: model)
        majorLabel.setJobisText(
            model.keyword,
            font: .body,
            color: .Primary.blue40
        )
    }
}
