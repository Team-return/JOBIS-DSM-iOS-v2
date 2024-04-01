import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

public enum AlertType {
    case positive
    case negative
}

final class JobisAlertViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var alertTitle: String?
    var message: String?
    var addActionConfirm: AddAction?
    var alertType: AlertType?

    private lazy var alertView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .GrayScale.gray10
    }

    private lazy var titleLabel = UILabel().then {
        $0.setJobisText(
            alertTitle ?? "",
            font: .headLine,
            color: .GrayScale.gray80
        )
    }

    private lazy var messageLabel = UILabel().then {
        $0.setJobisText(
            message ?? "",
            font: .body,
            color: .GrayScale.gray70
        )
        $0.numberOfLines = 0
    }

    private lazy var cancelButton = AlertButton(style: .cancel).then {
        $0.setText("취소")
    }
    private lazy var negativeButton = AlertButton(style: .negative).then {
        $0.setText(addActionConfirm?.text ?? "")
    }
    private lazy var positiveButton = AlertButton(style: .positive).then {
        $0.setText(addActionConfirm?.text ?? "")
    }

    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.rx.tapGesture().when(.recognized)
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        cancelButton.rx.tap.asObservable()
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        [
            negativeButton, positiveButton
        ].forEach { button in
            button.rx.tap.asObservable()
                .bind { [weak self] _ in
                    (self?.addActionConfirm?.action ?? {})()
                    self?.dismiss(animated: true)
                }
                .disposed(by: disposeBag)
        }
    }

    override func viewWillLayoutSubviews() {
        view.backgroundColor = .black.withAlphaComponent(0.5)

        view.addSubview(alertView)
        alertView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
        }

        alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }

        alertView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        alertView.addSubview(buttonStackView)
        var views: [UIView] {
            if alertType == .positive {
                return [positiveButton]
            }
            return [cancelButton, negativeButton]
        }
        views.forEach(buttonStackView.addArrangedSubview(_:))
        buttonStackView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(messageLabel.snp.bottom).offset(12)
        }
    }
}
