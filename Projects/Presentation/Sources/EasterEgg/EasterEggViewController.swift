import UIKit
import SwiftUI
import RxFlow
import RxCocoa
import RxSwift
import DesignSystem

public final class EasterEggViewController: RxFlowViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        contentViewController = UIHostingController(rootView: EasterEggView())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        self.hideTabbar()
    }
}
