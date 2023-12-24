import UIKit
import DesignSystem

final class ReviewNavigateView: UIView {
    var id = 0
    private let reviewImageView = UIImageView().then {
        $0.image = .jobisIcon(.door).resize(.init(width: 24, height: 24))
    }
    let titleLabel = UILabel().then {
        $0.font = .jobisFont(.description)
        $0.textColor = .GrayScale.gray70
    }
    let reviewNavigateButton = UIButton(type: .system).then {
        $0.setJobisText("작성하러 가기 →", font: .subHeadLine, color: .Primary.blue20)
    }
    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .Primary.blue10
        [
            reviewImageView,
            titleLabel,
            reviewNavigateButton
        ].forEach { self.addSubview($0) }

        reviewImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(reviewImageView.snp.trailing).offset(8)
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(16)
        }
        reviewNavigateButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(24)
            $0.leading.equalTo(reviewImageView.snp.trailing).offset(8)
        }
    }
}
