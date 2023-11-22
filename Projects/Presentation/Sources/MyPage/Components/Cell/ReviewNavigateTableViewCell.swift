import UIKit
import DesignSystem

class ReviewNavigateTableViewCell: UITableViewCell {
    static let identifier = "ReviewNavigateTableViewCell"
    private let reViewImageView = UIImageView().then {
        $0.image = .jobisIcon(.door)
    }
    let titleLabel = UILabel()
    let reviewNavigateButton = UIButton(type: .system).then {
        $0.setJobisText("작성하러 가기 →", font: .subHeadLine, color: .Main.blue1)
    }
    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        self.backgroundColor = DesignSystemAsset.Main.bg.color
        [
            reViewImageView,
            titleLabel,
            reviewNavigateButton
        ].forEach { self.addSubview($0) }

        reViewImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(reViewImageView.snp.trailing).offset(8)
        }
        reviewNavigateButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(reViewImageView.snp.trailing).offset(8)
        }
    }
}
