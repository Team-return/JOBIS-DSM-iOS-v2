import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class RecruitmentDetailViewController: BaseViewController<RecruitmentDetailViewModel> {
    var recruitmentID: Int?
    private var isBookmarked = false {
        didSet {
            var bookmarkImage: JobisIcon {
                isBookmarked ? .bookmarkOn: .bookmarkOff
            }
            bookmarkButton.setImage(
                .jobisIcon(bookmarkImage)
                .resize(size: 32), for: .normal
            )
        }
    }
    private var isSupported = true {
        didSet {
            var isApply: Bool {
                isSupported ? false: true
            }
            supportButton = JobisButton(style: .sub).then {
                $0.setText("3학년만 지원할 수 있어요")
            }
        }
    }
    private let companyLogoImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.GrayScale.gray30.cgColor
        $0.layer.cornerRadius = 8
    }
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "모집의뢰서 불러오는중...",
            font: .headLine,
            color: .GrayScale.gray90
        )
    }
    private let companyDetailButton = JobisButton(style: .sub).then {
        $0.setText("기업 상세 정보 보기")
    }
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainStackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
    }
    private let recruitmentPeriodLabel = RecruitmentDetailLabel(title: "모집기간")
    private let militaryServiceLabel = RecruitmentDetailLabel(title: "병역특례 여부")
    private let fieldTypeDetailTableView = UITableView().then {
        $0.register(
            FieldTypeDetailViewCell.self,
            forCellReuseIdentifier: FieldTypeDetailViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionHeaderTopPadding = 12
    }
    private let certificateLabel = RecruitmentDetailLabel(title: "자격증")
    private let recruitmentProcessLabel = RecruitmentDetailLabel(title: "채용절차")
    private let requiredGradeLabel = RecruitmentDetailLabel(title: "필수 성적")
    private let workingHoursLabel = RecruitmentDetailLabel(title: "근무시간")
    private let awardedMoneyLabel = RecruitmentDetailLabel(title: "실습 수당")
    private let permanentEmployeeLabel = RecruitmentDetailLabel(title: "정규직 전환 시")
    private let benefitsWelfareLabel = RecruitmentDetailLabel(title: "복리후생")
    private let needThingsLabel = RecruitmentDetailLabel(title: "제출 서류")
    private let otherMattersLabel = RecruitmentDetailLabel(title: "기타 사항")
    private var supportButton = JobisButton(style: .main).then {
        $0.setText("지원하기")
    }
    private let bookmarkButton = UIButton().then {
        $0.setImage(
            .jobisIcon(.bookmarkOff)
            .resize(size: 32), for: .normal
        )
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
    }

    public override func addView() {
        [
            scrollView,
            supportButton,
            bookmarkButton
        ].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)

        [
            recruitmentPeriodLabel,
            militaryServiceLabel,
            fieldTypeDetailTableView,
            certificateLabel,
            recruitmentProcessLabel,
            requiredGradeLabel,
            workingHoursLabel,
            awardedMoneyLabel,
            permanentEmployeeLabel,
            benefitsWelfareLabel,
            needThingsLabel,
            otherMattersLabel
        ].forEach(mainStackView.addArrangedSubview(_:))

        [
            companyLogoImageView,
            companyLabel,
            companyDetailButton,
            mainStackView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(supportButton.snp.top).inset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(mainStackView.snp.bottom).offset(20)
        }

        companyLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }

        companyLabel.snp.makeConstraints {
            $0.leading.equalTo(companyLogoImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(companyLogoImageView)
        }

        companyDetailButton.snp.makeConstraints {
            $0.top.equalTo(companyLogoImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }

        mainStackView.snp.makeConstraints {
            $0.top.equalTo(companyDetailButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }

        fieldTypeDetailTableView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(fieldTypeDetailTableView.contentSize.height)
        }

        supportButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(36)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(bookmarkButton.snp.leading).inset(-8)
        }

        bookmarkButton.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(36)
            $0.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = RecruitmentDetailViewModel.Input(
            viewAppear: self.viewDidLoadPublisher,
            companyDetailButtonDidClicked: companyDetailButton.rx.tap.asSignal(),
            bookMarkButtonDidTap: bookmarkButton.rx.tap.asSignal()
                .do(onNext: { [weak self] in
                    self?.isBookmarked.toggle()
                })
        )
        let output = viewModel.transform(input)

        output.recruitmentDetailEntity.asObservable()
            .bind { [self] in
                companyLogoImageView.setJobisImage(urlString: $0.companyProfileUrl)
                companyLabel.text = $0.companyName
                recruitmentPeriodLabel.setSubTitle("\($0.startDate) ~ \($0.endDate)")
                militaryServiceLabel.setSubTitle("병역특례 \($0.military ? "가능" : "불가능")")
                certificateLabel.setSubTitle($0.requiredLicenses)
                recruitmentProcessLabel.setSubTitle($0.hiringProgress)
                requiredGradeLabel.setSubTitle($0.requiredGrade)
                workingHoursLabel.setSubTitle($0.workingHours)
                awardedMoneyLabel.setSubTitle("\($0.trainPay) 만원/월")
                permanentEmployeeLabel.setSubTitle("\($0.pay ?? "0") 만원/년")
                benefitsWelfareLabel.setSubTitle($0.benefits)
                needThingsLabel.setSubTitle($0.submitDocument)
                otherMattersLabel.setSubTitle($0.etc)
                isBookmarked = $0.bookmarked
            }.disposed(by: disposeBag)

        output.areaListEntity.asObservable()
            .bind(to: fieldTypeDetailTableView.rx.items(
                cellIdentifier: FieldTypeDetailViewCell.identifier,
                cellType: FieldTypeDetailViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
                cell.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        fieldTypeDetailTableView.delegate = self

        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
            })
            .disposed(by: disposeBag)

        supportButton.rx.tap
            .subscribe(onNext: {
                self.isSupported.toggle()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension RecruitmentDetailViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FieldTypeDetailViewCell else { return }

        cell.isOpen.toggle()

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .transitionCrossDissolve
        ) {
            tableView.beginUpdates()
            cell.layoutIfNeeded()
            tableView.endUpdates()
        }
        tableView.layoutIfNeeded()

        self.fieldTypeDetailTableView.snp.remakeConstraints {
            $0.height.greaterThanOrEqualTo(self.fieldTypeDetailTableView.contentSize.height)
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return JobisMenuLabel(text: "모집분야")
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}
