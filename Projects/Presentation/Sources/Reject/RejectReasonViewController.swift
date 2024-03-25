import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class RejectReasonViewController: BaseBottomSheetViewController<RejectReasonViewModel> {
    private let titleLabel = UILabel().then {
        $0.setJobisText("반려 사유", font: .subBody, color: .GrayScale.gray60)
    }
    private let contentLabel = UILabel().then {
        $0.setJobisText("반려 사유 불러오는중...", font: .body, color: .GrayScale.gray90)
        $0.numberOfLines = 0
    }
    private let reApplyButton = JobisButton(style: .main).then {
        $0.setText("재지원 하기")
    }

    public override func addView() {
        [
            titleLabel,
            contentLabel,
            reApplyButton
        ].forEach(self.contentView.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualTo(reApplyButton.snp.top).offset(-28)
        }
        reApplyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottomMargin.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = RejectReasonViewModel.Input(
            viewWillAppear: viewWillAppearPublisher,
            reApplyButtonDidTap: reApplyButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)

        output.rejectReason.asObservable()
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)

    }

    public override func configureViewController() {
        viewDidLoadPublisher.asObservable()
            .bind {
                self.hideTabbar()
            }
            .disposed(by: disposeBag)
    }
}
