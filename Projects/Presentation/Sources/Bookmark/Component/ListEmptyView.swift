import UIKit
import SnapKit
import Then
import DesignSystem

public class ListEmptyView: BaseView {
    private let emptyImageView = UIImageView().then {
        $0.image = .jobisIcon(.listEmpty)
    }
    private let titleLabel = UILabel().then {
        $0.setJobisText("", font: .headLine, color: .GrayScale.gray90)
    }
    private let subTitleLabel = UILabel().then {
        $0.setJobisText("", font: .body, color: .GrayScale.gray60)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    public func setEmptyView(title: String, subTitle: String? = nil) {
        titleLabel.text = title
        subTitleLabel.text = subTitle ?? ""
    }

    public override func addView() {
        [
            emptyImageView,
            titleLabel,
            subTitleLabel
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
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
