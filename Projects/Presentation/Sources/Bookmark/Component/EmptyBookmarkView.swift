import UIKit
import SnapKit
import Then
import DesignSystem

class EmptyBookmarkView: BaseView {
    private let emptyImageView = UIImageView().then {
        $0.image = .jobisIcon(.emptyBookmark)
    }
    private let titleLabel = UILabel().then {
        $0.setJobisText("현재 등록해 둔 북마크가 없어요", font: .headLine, color: .GrayScale.gray90)
    }
    private let subTitleLabel = UILabel().then {
        $0.setJobisText(
            "현재 북마크가 되어있는 모집의뢰서가 없어요.\n모집의뢰서를 보고 맘에든다면\n우측 하단의 북마크 버튼을 눌러주세요!",
            font: .body,
            color: .GrayScale.gray60
        )
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    override func addView() {
        [
            emptyImageView,
            titleLabel,
            subTitleLabel
        ].forEach(self.addSubview(_:))
    }

    override func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(128)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
