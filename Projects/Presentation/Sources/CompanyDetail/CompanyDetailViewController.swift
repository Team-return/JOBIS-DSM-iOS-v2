import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class CompanyDetailViewController: BaseReactorViewController<CompanyDetailReactor> {
    private let companyDetailProfileView = CompanyDetailProfileView()
    public var isTabNavigation: Bool = true
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainStackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
    }
    private let bossLabel = CompanyDetailLabel(menuText: "대표자")
    private let serviceNameLabel = CompanyDetailLabel(menuText: "서비스 이름")
    private let startedDayLabel = CompanyDetailLabel(menuText: "설립일")
    private let workersNumbersLabel = CompanyDetailLabel(menuText: "근로자 수")
    private let annualSalesLabel = CompanyDetailLabel(menuText: "연매출")
    private let headAddressLabel = CompanyDetailLabel(menuText: "주소")
    private let businessAreaLabel = CompanyDetailLabel(menuText: "사업 분야")
    private let interviewReviewMenuLabel = JobisMenuLabel(text: "면접 후기")
    private let interviewReviewTableView = UITableView().then {
        $0.register(
            InterviewReviewTableViewCell.self,
            forCellReuseIdentifier: InterviewReviewTableViewCell.identifier
        )
        $0.rowHeight = 56
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    private let recruitmentButton = JobisButton(style: .main).then {
        $0.setText("모집의뢰서 보기")
        $0.isHidden = true
    }

    public override func addView() {
        [
            scrollView,
            recruitmentButton
        ].forEach(view.addSubview(_:))

        scrollView.addSubview(contentView)

        [
            bossLabel,
            serviceNameLabel,
            startedDayLabel,
            workersNumbersLabel,
            annualSalesLabel,
            headAddressLabel,
            businessAreaLabel
        ].forEach(mainStackView.addArrangedSubview(_:))

        [
            companyDetailProfileView,
            mainStackView,
            interviewReviewMenuLabel,
            interviewReviewTableView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(recruitmentButton.snp.top).inset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(interviewReviewTableView.snp.bottom).offset(20)
        }

        companyDetailProfileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        mainStackView.snp.makeConstraints {
            $0.top.equalTo(companyDetailProfileView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        interviewReviewMenuLabel.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(20)
        }

        interviewReviewTableView.snp.makeConstraints {
            $0.top.equalTo(interviewReviewMenuLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.safeAreaInsets)
            $0.height.greaterThanOrEqualTo(interviewReviewTableView.contentSize.height + 4)
        }

        recruitmentButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(36)
        }
    }

    public override func bindAction() {
        viewWillAppearPublisher
            .map { CompanyDetailReactor.Action.fetchCompanyDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        recruitmentButton.rx.tap
            .map { CompanyDetailReactor.Action.recruitmentButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        interviewReviewTableView.rx.modelSelected(ReviewEntity.self)
            .do(onNext: { [weak self] _ in
                self?.isTabNavigation = false
            })
            .map { CompanyDetailReactor.Action.interviewReviewDidSelect($0.reviewID, $0.writer) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state
            .compactMap { $0.companyDetail }
            .distinctUntilChanged { $0.companyName == $1.companyName }
            .bind(onNext: { [weak self] detail in
                self?.companyDetailProfileView.setCompanyProfile(
                    imageUrl: detail.companyProfileURL,
                    companyName: detail.companyName,
                    companyContent: detail.companyIntroduce
                )
                self?.bossLabel.setContent(contentText: detail.representativeName)
                self?.serviceNameLabel.setContent(contentText: detail.serviceName)
                self?.startedDayLabel.setContent(contentText: detail.foundedAt)
                self?.workersNumbersLabel.setContent(contentText: detail.workerNumber)
                self?.annualSalesLabel.setContent(contentText: detail.take)
                self?.headAddressLabel.setContent(contentText: detail.mainAddress)
                self?.businessAreaLabel.setContent(contentText: detail.businessArea)
                self?.recruitmentButton.isHidden = detail.recruitmentID == nil
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.reviewList }
            .distinctUntilChanged()
            .bind(to: interviewReviewTableView.rx.items(
                cellIdentifier: InterviewReviewTableViewCell.identifier,
                cellType: InterviewReviewTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() { }

    public override func configureNavigation() {
        self.setSmallTitle(title: "기업 상세")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}

extension UITableView {
    func setEmptyInterviewReviewView() {
        let headerView = EmptyInterviewReviewView()
        self.tableHeaderView = headerView
    }
}
