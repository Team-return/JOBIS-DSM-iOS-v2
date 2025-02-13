import UIKit
import Domain
import SnapKit
import Then
import DesignSystem
import RxSwift

final class LegendView: BaseView {
    private let legendColorView = UIView().then {
        $0.layer.cornerRadius = 3
    }
    private let legendLabel = UILabel()

    override func addView() {
        [
            legendColorView,
            legendLabel
        ].forEach { self.addSubview($0) }
    }
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.width.equalTo(47)
        }

        legendColorView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(6)
        }

        legendLabel.snp.makeConstraints {
            $0.leading.equalTo(legendColorView.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
    }
    public func setup(
        color: UIColor,
        textColor: UIColor,
        text: String
    ) {
        self.legendColorView.backgroundColor = color
        self.legendLabel.setJobisText(text, font: .subcaption, color: textColor)
    }
}
