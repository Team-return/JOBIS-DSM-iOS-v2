import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class InterviewReviewDetailViewController: BaseViewController<InterviewReviewDetailViewModel> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let pageTitleLabel = UILabel().then {
        $0.setJobisText(
            "- 님의 면접 후기",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 2
    }
    private let interviewReviewQuestionLabel = JobisMenuLabel(text: "받은 면접 질문")
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let questionListDetailStackView = QuestionListDetailStackView()

    public override func addView() {
        [
            questionListDetailStackView
        ].forEach { mainStackView.addArrangedSubview($0) }

        [
            pageTitleLabel,
            interviewReviewQuestionLabel,
            scrollView
        ].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
    }

    public override func setLayout() {
        pageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        interviewReviewQuestionLabel.snp.makeConstraints {
            $0.top.equalTo(pageTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(interviewReviewQuestionLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(mainStackView.snp.bottom).offset(20)
        }

        mainStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }

    public override func bind() {
        let input = InterviewReviewDetailViewModel.Input(
            viewWillAppear: self.viewWillAppearPublisher)

        let output = viewModel.transform(input)

        output.qnaListEntity.asObservable()
            .bind {
                self.questionListDetailStackView.setFieldType($0)
            }
            .disposed(by: disposeBag)

        self.pageTitleLabel.text = "\(output.writerName)님의 면접 후기"
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: {
                self.hideTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
