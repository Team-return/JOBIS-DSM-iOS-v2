import UIKit
import DesignSystem
import SnapKit
import Then

final class AttachmentURLsCollectionViewCell: BaseCollectionViewCell<String> {
    static let identifier = "AttachmentURLCollectionViewCell"

    private let linkImageView = UIImageView().then {
        $0.image = .jobisIcon(.link).resize(size: 24)
        $0.tintColor = UIColor.GrayScale.gray60
    }
    private let urlTextField = UITextField().then {
        $0.font = .jobisFont(.body)
        $0.placeholder = "링크를 입력해주세요"
        $0.textContentType = .URL
    }
    private let removeButton = UIImageView().then {
        $0.image = .jobisIcon(.close).resize(size: 24)
        $0.tintColor = UIColor.GrayScale.gray60
    }

    override func addView() {
        [
            linkImageView,
            urlTextField,
            removeButton
        ].forEach(addSubview(_:))
    }

    override func setLayout() {
        linkImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.bottom.leading.equalToSuperview().inset(12)
        }

        urlTextField.snp.makeConstraints {
            $0.centerY.equalTo(linkImageView)
            $0.leading.equalTo(linkImageView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().offset(-40)
        }

        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(linkImageView)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    override func configureView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .GrayScale.gray30
    }

    override func adapt(model: String) {
        super.adapt(model: model)
    }
}
