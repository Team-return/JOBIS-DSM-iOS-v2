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

    public override func addView() {
        [
            questionLabel,
            questionTextView,
            answerTextView,
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
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }
}
