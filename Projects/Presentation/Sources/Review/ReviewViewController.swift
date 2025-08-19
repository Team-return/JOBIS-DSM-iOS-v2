import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ReviewViewController: BaseViewController<ReviewViewModel> {
    public override func configureNavigation() {
        self.setLargeTitle(title: "후기")
    }
}
