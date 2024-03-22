import UIKit
import DesignSystem
import SnapKit
import Then
import Domain

final class AttachmentDocsTableViewCell: BaseTableViewCell<AttachmentsEntity> {
    static let identifier = "AttachmentDocsTableViewCell"

    private let backStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .GrayScale.gray30
    }
    private let docsNameLabel = UILabel().then {
        $0.setJobisText("", font: .body, color: .GrayScale.gray90)
    }
    private let removeButton = UIImageView().then {
        $0.image = .jobisIcon(.close).resize(size: 24)
        $0.tintColor = UIColor.GrayScale.gray60
    }

    override func addView() {
        addSubview(backStackView)
        [
            docsNameLabel,
            removeButton
        ].forEach(backStackView.addArrangedSubview(_:))
    }

    override func setLayout() {
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }

        backStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    override func configureView() { }

    override func adapt(model: AttachmentsEntity) {
        super.adapt(model: model)
        docsNameLabel.text = model.url
    }
}
