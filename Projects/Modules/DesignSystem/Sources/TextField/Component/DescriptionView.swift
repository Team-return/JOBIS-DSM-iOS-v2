import UIKit
import SnapKit
import Then

public final class DescriptionView: UIView {
    public var descriptionType: DescriptionType? {
        didSet {
            self.isHidden = false
            switch descriptionType {
            case .none:
                self.isHidden = true

            case let .error(description):
                self.descriptionLabel.setJobisText(description, font: .description, color: .Sub.red20)

            case let .info(description):
                self.descriptionLabel.setJobisText(description, font: .description, color: .GrayScale.gray90)

            case let .success(description):
                self.descriptionLabel.setJobisText(description, font: .description, color: .GrayScale.gray90)
            }
            self.imageView.image = descriptionType?.toIcon()
        }
    }
    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    public init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        [
            imageView,
            descriptionLabel
        ].forEach { addSubview($0) }
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.top.bottom.equalToSuperview().inset(2)
            $0.width.height.equalTo(16)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(4)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
