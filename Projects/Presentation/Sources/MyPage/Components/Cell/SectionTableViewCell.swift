import UIKit
import DesignSystem

typealias SectionType = (String, UIImage)
final class SectionTableViewCell: BaseTableViewCell<SectionType> {
    static let identifier = "SectionTableViewCell"
    private let sectionImageView = UIImageView()
    private let titleLabel = UILabel()

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.titleLabel.textColor = self.isHighlighted ? .GrayScale.gray50 : .GrayScale.gray90
    }

    override func addView() {
        [
            sectionImageView,
            titleLabel
        ].forEach { self.addSubview($0) }
    }

    override func setLayout() {
        sectionImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(28)
            $0.leading.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sectionImageView.snp.trailing).offset(8)
        }
    }

    override func adapt(model: SectionType) {
        self.sectionImageView.image = model.1
        self.titleLabel.setJobisText(model.0, font: .body, color: .GrayScale.gray90)
        self.selectionStyle = .none
    }
}
