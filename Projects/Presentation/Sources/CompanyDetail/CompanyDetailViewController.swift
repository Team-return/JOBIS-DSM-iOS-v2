import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class CompanyDetailViewController: BaseViewController<CompanyDetailViewModel> {
    private let companyLogoImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.GrayScale.gray30.cgColor
        $0.layer.cornerRadius = 8
    }
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "회사 정보 불러오는 중...",
            font: .headLine,
            color: .GrayScale.gray90
        )
    }
    private let explainCompanyLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray70
        )
    }
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
            companyLogoImageView,
            companyLabel,
            explainCompanyLabel,
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
            mainStackView,
            interviewReviewMenuLabel,
            interviewReviewTableView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        companyLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }

        companyLabel.snp.makeConstraints {
            $0.left.equalTo(companyLogoImageView.snp.right).offset(12)
            $0.centerY.equalTo(companyLogoImageView)
        }

        explainCompanyLabel.snp.makeConstraints {
            $0.top.equalTo(companyLogoImageView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(recruitmentButton.snp.top).inset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(interviewReviewTableView.snp.bottom).offset(20)
        }

        bossLabel.snp.makeConstraints {
            $0.top.equalTo(explainCompanyLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        startedDayLabel.snp.makeConstraints {
            $0.top.equalTo(bossLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        workersNumbersLabel.snp.makeConstraints {
            $0.top.equalTo(startedDayLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        annualSalesLabel.snp.makeConstraints {
            $0.top.equalTo(workersNumbersLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        headAddressLabel.snp.makeConstraints {
            $0.top.equalTo(annualSalesLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        chainAddressLabel.snp.makeConstraints {
            $0.top.equalTo(headAddressLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        firstManagerLabel.snp.makeConstraints {
            $0.top.equalTo(chainAddressLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        firstPhoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(firstManagerLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        secondManagerLabel.snp.makeConstraints {
            $0.top.equalTo(firstPhoneNumberLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        secondPhoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(secondManagerLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(secondPhoneNumberLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        faxLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        interviewReviewMenuLabel.snp.makeConstraints {
            $0.top.equalTo(faxLabel.snp.bottom).offset(20)
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
        self.setSmallTitle(title: "상세 보기")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}

extension UITableView {
    func setEmptyInterviewReviewView() {
        let headerView = EmptyInterviewReviewView()
        self.tableHeaderView = headerView
    }
}
