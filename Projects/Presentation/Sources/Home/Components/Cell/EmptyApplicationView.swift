import UIKit
import SnapKit
import Then
import Domain
import DesignSystem

final class EmptyApplicationView: UIView {
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        $0.clipsToBounds = true
    }
    private let emptyMessageLabel = UILabel().then {
        $0.setJobisText("현재 지원한 기업이 없어요", font: .body, color: .GrayScale.gray60)
    }

    override func layoutSubviews() {
        addSubview(containerView)
        containerView.addSubview(emptyMessageLabel)

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        emptyMessageLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
    }
}
