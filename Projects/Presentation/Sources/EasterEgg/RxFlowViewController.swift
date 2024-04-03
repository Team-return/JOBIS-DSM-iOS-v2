import UIKit
import RxFlow
import RxCocoa

public class RxFlowViewController: UIViewController, RxFlow.Stepper {
    public let steps = PublishRelay<Step>()
    var contentViewController = UIViewController()

    private var didSetupConstraints = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        setupConstraints()

    }

    fileprivate func setupConstraints() {
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
