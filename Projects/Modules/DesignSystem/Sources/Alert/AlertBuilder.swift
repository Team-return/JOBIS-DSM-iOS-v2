import UIKit

struct AddAction {
  var text: String?
  var action: (() -> Void)?
}

public final class AlertBuilder {
    private let baseViewController: UIViewController
    private let alertViewController = JobisAlertViewController()

    private var alertTitle: String?
    private var message: String?
    private var addActionConfirm: AddAction?
    private var alertType: AlertType?
    private var cancelText: String?

    public init(viewController: UIViewController) {
        baseViewController = viewController
    }

    public func setTitle(_ text: String) -> AlertBuilder {
        alertTitle = text
        return self
    }

    public func setMessage(_ text: String) -> AlertBuilder {
        message = text
        return self
    }

    public func addActionConfirm(_ text: String, action: (() -> Void)? = nil) -> AlertBuilder {
        addActionConfirm = AddAction(text: text, action: action)
        return self
    }

    public func setAlertType(_ type: AlertType) -> AlertBuilder {
        alertType = type
        return self
    }

    public func setCancelText(_ text: String) -> AlertBuilder {
        cancelText = text
        return self
    }

    @discardableResult
    public func show() -> Self {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve

        alertViewController.alertTitle = alertTitle
        alertViewController.message = message
        alertViewController.addActionConfirm = addActionConfirm
        alertViewController.alertType = alertType
        alertViewController.cancelText = cancelText

        baseViewController.present(alertViewController, animated: true)
        return self
    }
}
