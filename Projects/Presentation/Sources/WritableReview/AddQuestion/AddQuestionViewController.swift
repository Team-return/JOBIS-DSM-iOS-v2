import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class AddQuestionViewController: BaseViewController<AddQuestionViewModel> {
    private let questionLabel = UILabel().then {
        $0.setJobisText(
            "받았던 면접 질문을 추가해주세요!",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
    }

    private let questionTextView = ReviewTextView.small().then {
        $0.setTextView(
            title: "질문",
            placeholder: "example"
        )
    }

    private let answerTextView = ReviewTextView.medium().then {
        $0.setTextView(
            title: "답변",
            placeholder: "example"
        )
    }

    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }

    private let skipButton = UIButton().then {
        $0.setJobisText("건너뛸래요.", font: .subHeadLine, color: .GrayScale.gray50)
        $0.setUnderline()
    }

    public override func addView() {
        [
            questionLabel,
            questionTextView,
            answerTextView,
            skipButton,
            nextButton
        ].forEach { self.view.addSubview($0) }
    }

    public override func setLayout() {
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        questionTextView.snp.makeConstraints {
            $0.top.equalTo(questionLabel
                .snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        answerTextView.snp.makeConstraints {
            $0.top.equalTo(questionTextView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }

    public override func bind() {
        let input = AddQuestionViewModel.Input(
            questionText: questionTextView.textView.rx.text.orEmpty.asDriver(),
            answerText: answerTextView.textView.rx.text.orEmpty.asDriver(),
            nextButtonDidTap: nextButton.rx.tap.asSignal(),
            skipButtonDidTap: skipButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)

        output.isNextButtonEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
