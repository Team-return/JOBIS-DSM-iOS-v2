import UIKit
import SnapKit
import Then
import Domain
import DesignSystem

final class EmptyInterviewReviewView: BaseView {
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.GrayScale.gray40.cgColor
        $0.clipsToBounds = true
    }
    private let emptyMessageLabel = UILabel().then {
        $0.setJobisText("아직 후기가 없어요", font: .body, color: .GrayScale.gray60)
    }

    override func addView() {
        self.addSubview(containerView)
        self.containerView.addSubview(emptyMessageLabel)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        emptyMessageLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
    }
}
