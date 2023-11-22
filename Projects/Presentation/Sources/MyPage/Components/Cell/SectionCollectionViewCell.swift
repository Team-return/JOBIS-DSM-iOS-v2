import UIKit
import DesignSystem

class SectionTableViewCell: UITableViewCell {
    static let identifier = "SectionTableViewCell"
    let sectionImageView = UIImageView()
    let titleLabel = UILabel()

    override func layoutSubviews() {
        [
            sectionImageView,
            titleLabel
        ].forEach { self.addSubview($0) }

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
}
