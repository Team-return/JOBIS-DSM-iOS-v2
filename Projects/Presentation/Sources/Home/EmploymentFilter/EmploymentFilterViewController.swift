import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class EmploymentFilterViewController: BaseViewController<EmploymentFilterViewModel> {
    private let yearLabel = UILabel().then {
        $0.setJobisText("연도", font: .headLine, color: .GrayScale.gray90)
    }

    public override func addView() {
        [
            yearLabel
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
    }

    public override func bind() {
        let input = EmploymentFilterViewModel.Input(
            viewAppear: viewWillAppearPublisher
        )

        let output = viewModel.transform(input)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "필터")
    }
}
