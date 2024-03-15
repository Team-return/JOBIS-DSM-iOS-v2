import UIKit
import DesignSystem
import SnapKit
import Then

final class AttachmentDocsCollectionViewCell: BaseCollectionViewCell<URL> {
    static let identifier = "AttachmentDocsTableViewCell"

    private let docsNameLabel = UILabel().then {
        $0.setJobisText("", font: .body, color: .GrayScale.gray90)
    }
    private let removeButton = UIImageView().then {
        $0.image = .jobisIcon(.close).resize(size: 24)
        $0.tintColor = UIColor.GrayScale.gray60
    }

    override func addView() {
        [
            docsNameLabel,
            removeButton
        ].forEach(addSubview(_:))
    }

    override func setLayout() {
        docsNameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(removeButton.snp.trailing).offset(-16)
        }

        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(docsNameLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    override func configureView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .GrayScale.gray30
    }

    override func adapt(model: URL) {
        super.adapt(model: model)
        docsNameLabel.text = model.lastPathComponent
    }
}
