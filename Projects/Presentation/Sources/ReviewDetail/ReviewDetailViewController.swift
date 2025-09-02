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
}
