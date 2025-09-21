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

    private let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .GrayScale.gray60
    }

    private let addReviewTitleLabel = UILabel().then {
        $0.setJobisText(
            "면접관 수",
            font: .headLine,
            color: .GrayScale.gray60
        )
    }

    private let progressBarView = ProgressBarView()

    private let countTextView = ReviewTextView.small().then {
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
            backButton,
            addReviewTitleLabel,
            countTextView,
            progressBarView,
            nextButton
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(20)
        }

        addReviewTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
        }

        progressBarView.snp.makeConstraints {
            $0.top.equalTo(addReviewTitleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(backButton)
            $0.width.equalTo(70)
            $0.height.equalTo(6)
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

        progressBarView.configure(totalSteps: 4, currentStep: 4)
    }

    public func updateProgress(currentStep: Int) {
        progressBarView.configure(totalSteps: 4, currentStep: currentStep)
    }
}
