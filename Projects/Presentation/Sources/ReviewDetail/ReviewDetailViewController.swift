import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

enum DataType {
    case interviewReview
    case expectedQuestion
}

public final class ReviewDetailViewController: BaseViewController<ReviewDetailViewModel> {
    public var isPopViewController: ((String) -> Void)?
    private var interviewFormat: InterviewFormat?
    private var locationType: LocationType?
    private var interviewReview: [QnAEntity] = []
    private var expectedQuestion: [QnAEntity] = []
    private var currentDataType: DataType = .interviewReview
    private var writer: String = ""

    private let segmentedControl = UISegmentedControl(items: ["면접 후기", "예상 질문"]).then {
        $0.selectedSegmentIndex = 0
        $0.selectedSegmentTintColor = UIColor.GrayScale.gray10
        $0.layer.cornerRadius = 0
        $0.setTitleTextAttributes([
            .foregroundColor: UIColor.GrayScale.gray60,
            .font: UIFont.jobisFont(.body)
        ], for: .normal)
        $0.setTitleTextAttributes([
            .foregroundColor: UIColor.GrayScale.gray90,
            .font: UIFont.jobisFont(.body)
        ], for: .selected)
    }
    private let titleLabel = UILabel().then {
        $0.setJobisText("- 의 면접 후기", font: .pageTitle, color: UIColor.GrayScale.gray90)
    }
    private let yearLabel = UILabel().then {
        $0.setJobisText("-", font: .description, color: UIColor.GrayScale.gray70)
    }
    private let majorLabel = UILabel().then {
        $0.setJobisText("-", font: .description, color: UIColor.Primary.blue20)
    }
    private let dataContainerView = UIView()
    private let dataView = ReviewInfoView()
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let questionListDetailStackView = QuestionListDetailStackView()

    public override func addView() {
        [
            segmentedControl,
            titleLabel,
            yearLabel,
            majorLabel,
            dataContainerView,
            mainStackView
        ].forEach { view.addSubview($0) }
        dataContainerView.addSubview(dataView)
        [
            questionListDetailStackView
        ].forEach { mainStackView.addArrangedSubview($0) }
     }

    public override func setLayout() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }

        yearLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(24)
        }

        majorLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(yearLabel.snp.leading).offset(-12)
        }

        dataContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(20)
        }

        dataView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        mainStackView.snp.makeConstraints {
            $0.top.equalTo(dataContainerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
    }

    public override func bind() {
        let input = ReviewDetailViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher
        )
        let output = viewModel.transform(input)

        output.reviewDetailEntity.asObservable()
            .bind { [weak self] entity in
                guard let self = self else { return }
                self.writer = entity.writer
                self.titleLabel.text = "\(self.writer)의 면접 후기"
                self.yearLabel.text = "\(entity.year)"
                self.majorLabel.text = entity.major
                self.locationType = entity.location
                self.interviewFormat = entity.type
                self.dataView.configure(
                    company: entity.companyName,
                    area: self.getLocationText(),
                    interviewType: self.getInterviewFormatText(),
                    interviewerCount: entity.interviewerCount
                )
                self.questionListDetailStackView.setFieldType(entity.qnAs)
                self.interviewReview = entity.qnAs
                let qna = QnAEntity(id: 0, question: entity.question, answer: entity.answer)
                self.expectedQuestion = [qna]
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
                self?.navigationController?.navigationBar.prefersLargeTitles = false
            })
            .disposed(by: disposeBag)

        self.viewWillDisappearPublisher.asObservable()
            .bind {
                self.isPopViewController?(self.viewModel.reviewID!)
            }
            .disposed(by: disposeBag)

        self.segmentedControl.rx.selectedSegmentIndex
            .bind(onNext: { [weak self] index in
                guard let self = self else { return }
                self.currentDataType = index == 0 ? .interviewReview : .expectedQuestion
                switch self.currentDataType {
                case .interviewReview:
                    self.titleLabel.text = "\(self.writer)의 면접 후기"
                    self.questionListDetailStackView.setFieldType(interviewReview)
                case .expectedQuestion:
                    self.titleLabel.text = "\(self.writer)의 예상 면접 질문"
                    self.questionListDetailStackView.setFieldType(expectedQuestion)
                }
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "면접 후기 상세보기")
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func getInterviewFormatText() -> String {
        guard let format = interviewFormat else { return "-" }
        switch format {
        case .individual:
            return "개인 면접"
        case .group:
            return "단체 면접"
        case .other:
            return "기타 면접"
        }
    }

    private func getLocationText() -> String {
        guard let location = locationType else { return "-" }
        switch location {
        case .daejeon:
            return "대전"
        case .seoul:
            return "서울"
        case .gyeonggi:
            return "경기"
        case .other:
            return "기타"
        }
    }
}
