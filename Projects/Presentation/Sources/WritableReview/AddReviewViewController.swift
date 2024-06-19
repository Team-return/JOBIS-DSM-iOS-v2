import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class AddReviewViewController: BaseBottomSheetViewController<AddReviewViewModel> {
    private let searchButtonDidTap = PublishRelay<String>()
    public var dismiss: ((String, String, CodeEntity) -> Void)?
    private var appendTechCode = PublishRelay<CodeEntity>()
    private let addReviewButtonDidTap = PublishRelay<Void>()

    private var viewIsHidden = false {
        didSet {
            if viewIsHidden {
                addReviewView.isHidden = viewIsHidden
                techCodeView.isHidden = !viewIsHidden
            }
        }
    }

    private let addReviewView = AddReviewView()
    private let techCodeView = TechCodeView()

    public override func addView() {
        [
            addReviewView,
            techCodeView
        ].forEach(self.contentView.addSubview(_:))
    }

    public override func setLayout() {
        addReviewView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        techCodeView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }

    public override func bind() {
        let input = AddReviewViewModel.Input(
            viewWillAppear: viewWillAppearPublisher,
            appendTechCode: appendTechCode,
            addReviewButtonDidTap: addReviewButtonDidTap,
            searchButtonDidTap: searchButtonDidTap
        )

        let output = viewModel.transform(input)

        output.techList
            .bind { [weak self] in
                self?.techCodeView.techStackView.setTech(techList: $0)
                self?.techCodeView.techStackView.techDidTap = { code in
                    self?.appendTechCode.accept(code)
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.techCodeView.searchTextField.delegate = self
        techCodeView.isHidden = true
        addReviewView.nextButtonDidTap.asObservable()
            .subscribe(onNext: {
                self.viewIsHidden.toggle()
            })
            .disposed(by: disposeBag)

        techCodeView.addReviewButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.viewModel.question.accept(self.addReviewView.questionTextField.text ?? "")
                self.viewModel.answer.accept(self.addReviewView.answerTextView.text ?? "")

                self.dismiss?(
                    self.viewModel.question.value,
                    self.viewModel.answer.value,
                    self.viewModel.techCodeEntity
                )
                self.addReviewButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }
}

extension AddReviewViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonDidTap.accept(textField.text ?? "")
        self.view.endEditing(true)
        return true
    }
}
