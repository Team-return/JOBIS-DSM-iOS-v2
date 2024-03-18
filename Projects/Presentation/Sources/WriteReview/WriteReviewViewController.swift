import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class WriteReviewViewController: BaseViewController<WriteReviewViewModel> {
    public override func addView() { }

    public override func setLayout() { }

    public override func configureViewController() {
        setLargeTitle(title: "다른 학생들을 위하여 면접의 후기를 작성해주세요")
    }

    public override func configureNavigation() { }
}
