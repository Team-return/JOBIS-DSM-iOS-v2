import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class InterviewAtmosphereViewController: BaseViewController<InterviewAtmosphereViewModel> {
    private let nextButtonDidTap = PublishRelay<Void>()

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }

    private let contentView = UIView()

    private let progressBarView = ProgressBarView()

    private let questionLabel = UILabel().then {
        $0.setJobisText("질문을 불러오는 중...", font: .pageTitle, color: .GrayScale.gray90)
        $0.numberOfLines = 0
    }

    private let answerTitleLabel = UILabel().then {
        $0.setJobisText("답변", font: .body, color: .GrayScale.gray90)
    }

    private let atmosphereTextView = ReviewTextView().then {
        $0.placeholder = "면접 후기를 성심성의껏 작성해 주세요!"
        $0.placeholderColor = UIColor.GrayScale.gray60
        $0.textView.isScrollEnabled = true
        $0.textView.isEditable = true
        $0.textView.isSelectable = true
        $0.textView.isUserInteractionEnabled = true
    }

    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }

    private var output: InterviewAtmosphereViewModel.Output!
    private var isUpdatingFromViewModel = false

    public override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            progressBarView,
            questionLabel,
            answerTitleLabel,
            atmosphereTextView
        ].forEach { contentView.addSubview($0) }
        view.addSubview(nextButton)
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(54)
            $0.height.equalTo(6)
        }
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        answerTitleLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        atmosphereTextView.snp.makeConstraints {
            $0.top.equalTo(answerTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }

    public override func bind() {
        let input = InterviewAtmosphereViewModel.Input(
            viewWillAppear: viewWillAppearPublisher.asObservable(),
            atmosphereText: atmosphereTextView.textView.rx.text.orEmpty
                .filter { [weak self] _ in
                    !(self?.isUpdatingFromViewModel ?? false)
                }
                .asObservable(),
            nextButtonDidTap: nextButtonDidTap.asObservable()
        )

        output = viewModel.transform(input)

        output.isNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.currentQuestion
            .bind(to: questionLabel.rx.text)
            .disposed(by: disposeBag)

        output.loadAnswerForCurrentQuestion
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (text: String) in
                guard let self = self else { return }
                self.isUpdatingFromViewModel = true
                self.atmosphereTextView.textView.text = text

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isUpdatingFromViewModel = false
                }
            })
            .disposed(by: disposeBag)

        setupProgressTracking(output: output)
    }

    public override func configureViewController() {
        self.hideTabbar()

        nextButton.rx.tap
            .bind(to: nextButtonDidTap)
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            }
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.adjustForKeyboard(height: keyboardHeight, isShowing: true)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.adjustForKeyboard(height: 0, isShowing: false)
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "면접 질문"
    }

    private func adjustForKeyboard(height: CGFloat, isShowing: Bool) {
        nextButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(isShowing ? height + 24 : 24)
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func setupProgressTracking(output: InterviewAtmosphereViewModel.Output) {
        Observable.combineLatest(
            output.questions,
            output.currentQuestionIndex
        )
        .subscribe(onNext: { [weak self] questions, currentIndex in
            self?.progressBarView.configure(totalSteps: questions.count, currentStep: currentIndex + 1)
        })
        .disposed(by: disposeBag)
    }
}
