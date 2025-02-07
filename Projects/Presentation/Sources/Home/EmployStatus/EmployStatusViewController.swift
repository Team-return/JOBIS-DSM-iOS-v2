import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class EmployStatusViewController: BaseViewController<EmployStatusViewModel> {
    public override func configureNavigation() {
        setSmallTitle(title: "취업 현황")
    }
    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: {
                self.hideTabbar()
            })
            .disposed(by: disposeBag)
    }
}
