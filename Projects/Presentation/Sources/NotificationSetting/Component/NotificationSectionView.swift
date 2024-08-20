import UIKit
import Domain
import SnapKit
import Then
import RxSwift
import RxCocoa
import DesignSystem

public final class NotificationSectionView: BaseView {
    public var disposeBag = DisposeBag()

    private let notificationTitleLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .subHeadLine,
            color: .GrayScale.gray70
        )
    }
    private lazy var notificationSwitchButton = UISwitch().then {
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
        notificationTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        notificationSwitchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }

    public override func configureView() {
        self.notificationSwitchButton.rx.tapGesture()
            .subscribe(onNext: { _ in
                self.notificationSwitchButton.isOn.toggle()
                if self.notificationSwitchButton.isOn {
                    self.notificationSwitchButton.thumbTintColor = .white
                    print("온!!")
                } else {
                    self.notificationSwitchButton.thumbTintColor = nil
                    print("오프!!")
                }
            })
            .disposed(by: disposeBag)
    }

    func setTitleLabel(text: String) {
        self.notificationTitleLabel.text = text
    }
}
