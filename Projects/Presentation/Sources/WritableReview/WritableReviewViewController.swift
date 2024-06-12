import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class WritableReviewViewController: BaseViewController<WritableReviewViewModel> {
    private let addReviewButtonDidTap = PublishRelay<Void>()
//    private let interviewReviewList = BehaviorRelay<>

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
//        $0.isHidden = true
    }
    private let emptyQuestionLabel = UILabel().then {
        $0.setJobisText(
            "현재 입력 된 질문이 없어요",
            font: .subBody,
            color: .GrayScale.gray60
        )
    }
    private let questionListDetailStackView = QuestionListDetailStackView()
    private let addReviewButton = JobisButton(style: .sub).then {
        $0.setText("질문 추가하기")
    }
    private var writableReviewButton = JobisButton(style: .main).then {
        $0.setText("후기를 작성해주세요")
    }

    public override func addView() {
        emptyQuestionListView.addSubview(emptyQuestionLabel)

        [
            emptyQuestionListView,
            questionListDetailStackView,
            addReviewButton
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
//            viewWillAppear: self.viewWillAppearPublisher,
            addReviewButtonDidTap: addReviewButtonDidTap
        )

        let output = viewModel.transform(input)

//        output.companyListInfo
//            .skip(1)
//            .do(onNext: {
//                self.emptySearchView.isHidden = !$0.isEmpty
//            })
//            .bind(to: searchTableView.rx.items(
//                cellIdentifier: CompanyTableViewCell.identifier,
//                cellType: CompanyTableViewCell.self
//            )) { _, element, cell in
//                cell.adapt(model: element)
//            }
//            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: {
                self.hideTabbar()
//                self.questionListDetailStackView.setFieldType($0) 이거 output으로 옮겨야함
            })
            .disposed(by: disposeBag)

        addReviewButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.addReviewButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
