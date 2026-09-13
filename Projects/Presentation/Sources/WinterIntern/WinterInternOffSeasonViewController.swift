import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import DesignSystem
import ReactorKit

public final class WinterInternOffSeasonViewController: BaseReactorViewController<WinterInternOffSeasonReactor> {
    private let emptyView = ListEmptyView().then {
        $0.setEmptyView(
            title: "현재 현장실습 공고 시즌이 아니에요",
            subTitle: "시즌이 올 때까지 기다려주세요"
        )
    }

    public override func addView() {
        self.view.addSubview(emptyView)
    }

    public override func setLayout() {
        emptyView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func configureViewController() {
        viewWillAppearPublisher.asObservable()
            .bind(with: self, onNext: { owner, _ in
                owner.hideTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "체험형 현장실습")
    }
}
