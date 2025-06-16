import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MajorCollectionViewCell: BaseCollectionViewCell<CodeEntity> {
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

    private var disposeBag = DisposeBag()
    private let majorLabel = UILabel()

    override func addView() {
        self.contentView.addSubview(majorLabel)
    }

    override func setLayout() {
        majorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(31)
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 15.5
        self.layer.masksToBounds = true
        majorLabel.textAlignment = .center
        majorLabel.font = UIFont.jobisFont(.body)
        majorLabel.numberOfLines = 1
        majorLabel.lineBreakMode = .byClipping
        majorLabel.adjustsFontSizeToFitWidth = false
    }

    override func adapt(model: CodeEntity) {
        super.adapt(model: model)
        majorLabel.setJobisText(model.keyword, font: .body, color: .Primary.blue40)
        invalidateIntrinsicContentSize()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 31)
        let fittingSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )

        let minWidth: CGFloat = 60
        let width = max(fittingSize.width, minWidth)

        layoutAttributes.frame.size = CGSize(width: width, height: 31)
        return layoutAttributes
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = majorLabel.intrinsicContentSize
        let width = labelSize.width + 32
        return CGSize(width: width, height: 31)
    }
}
