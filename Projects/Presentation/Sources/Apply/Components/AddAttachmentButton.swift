import UIKit
import DesignSystem
import SnapKit
import RxSwift
import Then

enum AttachedType: String {
    case docs = "파일"
    case urls = "URL"
}

final class AddAttachmentButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.GrayScale.gray40.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI(_ type: AttachedType) {
        let image: UIImage? = .jobisIcon(.plus)
            .withTintColor(.GrayScale.gray60, renderingMode: .alwaysTemplate)
            .resize(size: 24)

        var config = UIButton.Configuration.plain()
        config.image = image
        config.title = type.rawValue + " 추가하기"
        config.attributedTitle?.foregroundColor = UIColor.GrayScale.gray60
        config.attributedTitle?.font = UIFont.jobisFont(.subBody)
        config.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)

        self.configuration = config
    }
}
