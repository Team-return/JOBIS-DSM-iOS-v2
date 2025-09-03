import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class ReviewFilterViewController: BaseViewController<ReviewFilterViewModel> {
    public override func configureViewController() {

        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.setSmallTitle(title: "필터 설정")
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}
