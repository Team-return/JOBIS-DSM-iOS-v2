import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterestFieldCheckViewController: BaseViewController<InterestFieldCheckViewModel> {
    private let interestView = InterestCheckView()

    public override func addView() {
        [
            interestView
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        interestView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }

    public override func configureNavigation() {
        setSmallTitle(title: "관심 분야 선택")
        self.navigationItem.largeTitleDisplayMode = .never
    }

    public override func bind() {
        super.bind()

        let input = InterestFieldCheckViewModel.Input(
            viewWillAppear: viewWillAppearPublisher.asObservable()
        )

        let output = viewModel.transform(input)

        output.studentName
            .drive(onNext: { [weak self] name in
                self?.interestView.setStudentName(name)
            })
            .disposed(by: disposeBag)
    }
}
