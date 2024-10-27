import UIKit
import Domain
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

public final class NotificationSectionView: BaseView {
    public var disposeBag = DisposeBag()
    public var switchIsOn: Bool {
        return notificationSwitchButton.isOn
    }
    public var clickSwitchButton: ControlProperty<Bool> {
        return notificationSwitchButton.rx.isOn
    }

    private let notificationTitleLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .subHeadLine,
            color: .GrayScale.gray70
        )
    }
    public lazy var notificationSwitchButton = UISwitch().then {
        $0.onTintColor = .Primary.blue30
        $0.thumbTintColor = .GrayScale.gray50
    }

    public override func addView() {
        [
            notificationTitleLabel,
            notificationSwitchButton
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }

        notificationTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        notificationSwitchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }

    func setTitleLabel(text: String) {
        self.notificationTitleLabel.text = text
    }

    public func setup(
        isOn: Bool
    ) {
        self.notificationSwitchButton.setOn(isOn, animated: true)
        self.notificationSwitchButton.thumbTintColor = .white
    }
}
