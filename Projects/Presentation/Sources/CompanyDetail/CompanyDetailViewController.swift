import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class CompanyDetailViewController: BaseViewController<CompanyDetailViewModel> {
    private let companyDetailProfileView = CompanyDetailProfileView()
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainStackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
    }
    private let bossLabel = CompanyDetailLabel(menuText: "대표자")
    private let startedDayLabel = CompanyDetailLabel(menuText: "설립일")
    private let workersNumbersLabel = CompanyDetailLabel(menuText: "근로자 수")
    private let annualSalesLabel = CompanyDetailLabel(menuText: "연매출")
    private let headAddressLabel = CompanyDetailLabel(menuText: "주소(본사)")
    private let chainAddressLabel = CompanyDetailLabel(menuText: "주소(지점)")
    private let firstManagerLabel = CompanyDetailLabel(menuText: "담당자1")
    private let firstPhoneNumberLabel = CompanyDetailLabel(menuText: "전화번호1")
    private let secondManagerLabel = CompanyDetailLabel(menuText: "담당자2")
    private let secondPhoneNumberLabel = CompanyDetailLabel(menuText: "전화번호2")
    private let emailLabel = CompanyDetailLabel(menuText: "이메일")
    private let faxLabel = CompanyDetailLabel(menuText: "팩스")
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
            startedDayLabel,
            workersNumbersLabel,
            annualSalesLabel,
            headAddressLabel,
            chainAddressLabel,
            firstManagerLabel,
            firstPhoneNumberLabel,
            secondManagerLabel,
            secondPhoneNumberLabel,
            emailLabel,
            faxLabel
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

    public override func bind() {
        let input = CompanyDetailViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            recruitmentButtonDidTap: recruitmentButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)

        output.companyDetailInfo
            .bind(onNext: { [self] in
                companyDetailProfileView.setCompanyProfile(
                    imageUrl: $0.companyProfileURL,
                    companyName: $0.companyName,
                    companyContent: $0.companyIntroduce
                )
                bossLabel.setContent(contentText: $0.representativeName)
                startedDayLabel.setContent(contentText: $0.foundedAt)
                workersNumbersLabel.setContent(contentText: $0.workerNumber)
                annualSalesLabel.setContent(contentText: $0.take)
                headAddressLabel.setContent(contentText: $0.mainAddress)
                chainAddressLabel.setContent(contentText: $0.subAddress ?? "-")
                firstManagerLabel.setContent(contentText: $0.managerName)
                firstPhoneNumberLabel.setContent(contentText: $0.managerPhoneNo)
                secondManagerLabel.setContent(contentText: $0.subManagerName ?? "-")
                secondPhoneNumberLabel.setContent(contentText: $0.subManagerPhoneNo ?? "-")
                emailLabel.setContent(contentText: $0.email)
                faxLabel.setContent(contentText: $0.fax ?? "-")
                viewModel.recruitmentID = $0.recruitmentID
                recruitmentButton.isHidden = $0.recruitmentID == nil
            })
            .disposed(by: disposeBag)

        output.reviewListInfo.asObservable()
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
