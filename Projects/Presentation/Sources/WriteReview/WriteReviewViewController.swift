import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class WriteReviewViewController: BaseViewController<WriteReviewViewModel> {
    private let titleLabel = UILabel().then {
        $0.setJobisText(
            "다른 학생들을 위하여\n면접의 후기를 작성해주세요",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
    }
    public override func addView() {
        [
            titleLabel
        ].forEach(self.view.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    public override func configureViewController() {
        viewWillAppearPublisher.asObservable()
            .bind {
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}
