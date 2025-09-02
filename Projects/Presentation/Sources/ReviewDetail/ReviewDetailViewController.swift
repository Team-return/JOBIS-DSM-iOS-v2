import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ReviewDetailViewController: BaseViewController<ReviewDetailViewModel> {
    public var isPopViewController: ((Int) -> Void)?

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
                self?.navigationController?.navigationBar.prefersLargeTitles = false
            })
            .disposed(by: disposeBag)

        self.viewWillDisappearPublisher.asObservable()
            .bind {
                self.isPopViewController?(self.viewModel.reviewID!)
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}
