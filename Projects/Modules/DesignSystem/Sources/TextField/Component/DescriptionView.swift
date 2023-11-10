import UIKit
import SnapKit
import Then

public class DescriptionView: UIView {
    public var descriptionType: DescriptionType = .error(description: "") {
        didSet {
            switch descriptionType {
            case .none:
                self.isHidden = true
            case let .error(description):
                self.descriptionLabel.setJobisText(description, font: .description)
                self.imageView.image = .textFieldIcon(.erorr)
                self.descriptionLabel.textColor = .Sub.red
            case let .info(description):
                self.descriptionLabel.setJobisText(description, font: .description)
                self.imageView.image = .textFieldIcon(.info)
                self.descriptionLabel.textColor = .Sub.blue
            case let .success(description):
                self.descriptionLabel.setJobisText(description, font: .description)
                self.imageView.image = .textFieldIcon(.success)
                self.descriptionLabel.textColor = .Sub.green
            }
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
