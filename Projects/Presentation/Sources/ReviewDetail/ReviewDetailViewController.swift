import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ReviewDetailViewController: BaseReactorViewController<ReviewDetailReactor> {
    public var isPopViewController: ((String) -> Void)?

    private let segmentedControl = UISegmentedControl(items: ["면접 후기", "받은 질문"]).then {
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

    public override func bindAction() {
        viewDidLoadPublisher
            .map { ReviewDetailReactor.Action.fetchReviewDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        segmentedControl.rx.selectedSegmentIndex
            .map { ReviewDetailReactor.Action.segmentSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state
            .map { $0.titleText }
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.year }
            .distinctUntilChanged()
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.major }
            .distinctUntilChanged()
            .bind(to: majorLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.reviewDetailEntity }
            .distinctUntilChanged { $0.companyName == $1.companyName }
            .bind(onNext: { [weak self] _ in
                guard let self = self,
                      let state = self.reactor.currentState else { return }
                self.dataView.configure(
                    company: state.companyName,
                    area: state.locationText,
                    interviewType: state.interviewFormatText,
                    interviewerCount: state.interviewerCount
                )
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.currentQnAs }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] qnAs in
                self?.questionListDetailStackView.setFieldType(qnAs)
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.rx.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.hideTabbar()
                self?.navigationController?.navigationBar.prefersLargeTitles = false
            })
            .disposed(by: disposeBag)

        self.rx.viewWillDisappear
            .subscribe(onNext: { [weak self] _ in
                guard let reviewID = self?.reactor.reviewID else { return }
                self?.isPopViewController?(reviewID)
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "면접 후기 상세보기")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
