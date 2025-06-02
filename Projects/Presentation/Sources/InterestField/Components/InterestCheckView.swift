import UIKit
import SnapKit
import Then

final class InterestCheckView: BaseView {
    private let checkImageView = UIImageView().then {
        $0.image = .jobisIcon(.check)
    }

    private let checkLabel = UILabel().then {
        $0.setJobisText(
            "님의 \n관심사를 확인했어요!",
            font: .smallBody,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let checkExplainLabel = UILabel().then {
        $0.setJobisText(
            "관심사에 맞는 모집 의뢰서가 업로드되면\n알림을 드립니다!",
            font: .description,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    override func addView() {
        [
            checkImageView,
            checkLabel,
            checkExplainLabel
        ].forEach(self.addSubview(_:))
    }

    override func setLayout() {
        checkImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }

        checkLabel.snp.makeConstraints {
            $0.top.equalTo(checkImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        checkExplainLabel.snp.makeConstraints {
            $0.top.equalTo(checkLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

}
