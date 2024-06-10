import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class AddReviewViewController: BaseBottomSheetViewController<AddReviewViewModel> {
    private let addReviewTitleLabel = UILabel().then {
        $0.setJobisText(
            "질문 추가하기",
            font: .subBody,
            color: .GrayScale.gray60
        )
    }
    private let questionLabel = UILabel().then {
        $0.setJobisText(
            "질문",
            font: .description,
            color: .GrayScale.gray90
        )
    }
    private let questionTextField = UITextField().then {
        $0.placeholder = "example"
        $0.setPlaceholderColor(.GrayScale.gray60)
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .GrayScale.gray10
        $0.font = UIFont.jobisFont(.body)
        $0.addLeftPadding(size: 16)
        $0.addRightPadding(size: 16)
    }
    private let answerLabel = UILabel().then {
        $0.setJobisText(
            "답변",
            font: .description,
            color: .GrayScale.gray90
        )
    }
    private let answerTextView = UITextView().then {
        $0.text = "example"
        $0.layer.cornerRadius = 12
        $0.textColor = UIColor.GrayScale.gray60
        $0.backgroundColor = .GrayScale.gray10
        $0.font = UIFont.jobisFont(.body)
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
    }

    public override func addView() {
        [
            addReviewTitleLabel,
            questionLabel,
            questionTextField,
            answerLabel,
            answerTextView,
            nextButton
        ].forEach(self.contentView.addSubview(_:))
    }

    public override func setLayout() {
        addReviewTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        }

        questionLabel.snp.makeConstraints {
            $0.top.equalTo(addReviewTitleLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(24)
        }

        questionTextField.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }

        answerLabel.snp.makeConstraints {
            $0.top.equalTo(questionTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }

        answerTextView.snp.makeConstraints {
            $0.top.equalTo(answerLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(nextButton.snp.top).inset(-24)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }

    public override func bind() {
        let input = AddReviewViewModel.Input(
//            viewWillAppear: viewWillAppearPublisher
        )
        let output = viewModel.transform(input)
    }

    public override func configureViewController() {
        answerTextView.delegate = self
        viewDidLoadPublisher.asObservable()
            .bind {
                self.hideTabbar()
            }
            .disposed(by: disposeBag)
    }
}

extension AddReviewViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.GrayScale.gray60 {
            textView.text = nil
            textView.textColor = UIColor.GrayScale.gray90
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "example"
            textView.textColor = UIColor.GrayScale.gray60
        }
    }
}
