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
    public var dismiss: ((String, String, CodeEntity, InterviewFormat?, LocationType?) -> Void)?
    private var appendTechCode = PublishRelay<CodeEntity>()
    private let addReviewButtonDidTap = PublishRelay<Void>()
    public var companyName: String?

    private var currentViewIndex = 0 {
        didSet {
            updateViewVisibility()
        }
    }

    private let addReviewView = AddReviewView()
    private let areaReviewView = AreaReviewView()
    private let techCodeView = TechCodeView()
    private let interviewersCountView = InterviewersCountView()
    private let infoCheckView = InfoCheckView()
    private var currentInterviewFormat: InterviewFormat?

    public override func addView() {
        [
            addReviewView,
            areaReviewView,
            techCodeView,
            interviewersCountView,
            infoCheckView
        ].forEach(self.contentView.addSubview(_:))
    }

    public override func setLayout() {
        addReviewView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        areaReviewView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        techCodeView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        interviewersCountView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        infoCheckView.snp.makeConstraints {
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

        addReviewView.selectedFormat.asObservable()
            .bind { [weak self] in
                self?.currentInterviewFormat = $0
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.techCodeView.searchTextField.delegate = self
        updateViewVisibility()

        addReviewView.selectedFormat
            .map { $0 != nil }
            .bind(to: addReviewView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        addReviewView.nextButtonDidTap.asObservable()
            .subscribe(onNext: {
                self.currentInterviewFormat = self.addReviewView.selectedFormat.value
                self.currentViewIndex = 1
            })
            .disposed(by: disposeBag)

        areaReviewView.selectedLocation
            .map { $0 != nil }
            .bind(to: areaReviewView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        areaReviewView.nextButtonDidTap.asObservable()
            .subscribe(onNext: {
                self.currentViewIndex = 2
            })
            .disposed(by: disposeBag)

        appendTechCode.asObservable()
            .bind { techCode in
                if techCode.keyword != "" {
                    self.techCodeView.addReviewButton.isEnabled = true
                } else {
                    self.techCodeView.addReviewButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)

        techCodeView.addReviewButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.currentViewIndex = 3
            })
            .disposed(by: disposeBag)

        interviewersCountView.nextButtonDidTap.asObservable()
            .subscribe(onNext: {
                let companyFromFlow = self.companyName
                let fallbackTitle = self.navigationItem.title
                let companyName = (companyFromFlow?.isEmpty == false) ? companyFromFlow : fallbackTitle
                self.infoCheckView.setInfo(
                    format: self.currentInterviewFormat,
                    location: self.areaReviewView.selectedLocation.value,
                    tech: self.viewModel.techCodeEntity,
                    interviewersCount: self.interviewersCountView.countText,
                    question: self.viewModel.question.value,
                    answer: self.viewModel.answer.value,
                    companyName: companyName
                )
                self.currentViewIndex = 4
            })
            .disposed(by: disposeBag)

        infoCheckView.nextButtonDidTap.asObservable()
            .subscribe(onNext: {
                self.dismiss?(
                    self.viewModel.question.value,
                    self.viewModel.answer.value,
                    self.viewModel.techCodeEntity,
                    self.currentInterviewFormat,
                    self.areaReviewView.selectedLocation.value
                )
                self.addReviewButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    private func updateViewVisibility() {
        addReviewView.isHidden = currentViewIndex != 0
        areaReviewView.isHidden = currentViewIndex != 1
        techCodeView.isHidden = currentViewIndex != 2
        interviewersCountView.isHidden = currentViewIndex != 3
        infoCheckView.isHidden = currentViewIndex != 4
    }
}

extension AddReviewViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonDidTap.accept(textField.text ?? "")
        self.view.endEditing(true)
        return true
    }
}
