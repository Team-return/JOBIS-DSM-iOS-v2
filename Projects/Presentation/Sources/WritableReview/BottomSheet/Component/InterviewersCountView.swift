import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterviewersCountView: BaseView {
    private let disposeBag = DisposeBag()
    private let addReviewTitleLabel = UILabel().then {
        $0.setJobisText(
            "면접관 수",
            font: .headLine,
            color: .GrayScale.gray60
        )
    }

    private let countTextView = ReviewTextView().then {
        $0.setTextView(
            title: "답변",
            placeholder: "면접관수를 작성해주세요."
        )
    }

    public let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }
    public let nextButtonDidTap = PublishRelay<Void>()
    public var countText: String { countTextView.textView.text ?? "" }

    public override func addView() {
        [
            addReviewTitleLabel,
            countTextView,
            nextButton
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        addReviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(24)
            $0.leading.equalTo(24)
        }
        countTextView.snp.makeConstraints {
            $0.top.equalTo(addReviewTitleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }

    public override func configureView() {
        nextButton.rx.tap
            .bind(to: nextButtonDidTap)
            .disposed(by: disposeBag)

        countTextView.textView.rx.text.orEmpty
            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
