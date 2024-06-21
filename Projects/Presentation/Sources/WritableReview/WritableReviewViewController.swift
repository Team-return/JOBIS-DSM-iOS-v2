import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class WritableReviewViewController: BaseViewController<WritableReviewViewModel> {
    private let addQuestionButtonDidTap = PublishRelay<Void>()
    private let writableReviewButtonDidTap = PublishRelay<Void>()

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let pageTitleLabel = UILabel().then {
        $0.setJobisText(
            "다른 학생들을 위하여\n면접의 후기를 작성해주세요",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 2
    }
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let emptyQuestionListView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.GrayScale.gray40.cgColor
    }
    private let emptyQuestionLabel = UILabel().then {
        $0.setJobisText(
            "현재 입력 된 질문이 없어요",
            font: .subBody,
            color: .GrayScale.gray60
        )
    }
    private let questionListDetailStackView = QuestionListDetailStackView()
    private let addQuestionButton = JobisButton(style: .sub).then {
        $0.setText("질문 추가하기")
    }
    private var writableReviewButton = JobisButton(style: .main).then {
        $0.setText("후기를 작성해주세요")
        $0.isEnabled = false
    }

    public override func addView() {
        emptyQuestionListView.addSubview(emptyQuestionLabel)

        [
            emptyQuestionListView,
            questionListDetailStackView,
            addQuestionButton
        ].forEach { mainStackView.addArrangedSubview($0) }

        [
            pageTitleLabel,
            scrollView,
            writableReviewButton
        ].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
    }

    public override func setLayout() {
        emptyQuestionListView.snp.makeConstraints {
            $0.height.equalTo(52)
        }

        emptyQuestionLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        pageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(writableReviewButton.snp.top).inset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(mainStackView.snp.bottom).offset(20)
        }

        mainStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        writableReviewButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = WritableReviewViewModel.Input(
            viewWillAppear: self.viewWillAppearPublisher,
            addQuestionButtonDidTap: addQuestionButtonDidTap,
            writableReviewButtonDidTap: writableReviewButtonDidTap
        )

        let output = viewModel.transform(input)

        output.qnaInfoList.asObservable()
            .bind(onNext: {
                self.questionListDetailStackView.setFieldType($0)
            })
            .disposed(by: disposeBag)

        output.interviewReviewInfoList.asObservable()
            .bind(onNext: {
                self.emptyQuestionListView.isHidden = !$0.isEmpty
                if !$0.isEmpty {
                    self.showJobisToast(text: "질문이 추가되었어요!", inset: 92)
                    self.writableReviewButton.isEnabled = true
                    self.writableReviewButton.setText("작성 완료")
                }
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: {
                self.hideTabbar()
            })
            .disposed(by: disposeBag)

        addQuestionButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.addQuestionButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)

        writableReviewButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.writableReviewButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
