import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class RecruitmentDetailViewController: BaseReactorViewController<RecruitmentDetailReactor> {
    public var isPopViewController: ((Int, Bool) -> Void)?
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
    private let companyProfileView = CompanyProfileView()
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainStackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
    }
    private let recruitmentPeriodLabel = RecruitmentDetailLabel(title: "모집기간")
    private let militaryServiceLabel = RecruitmentDetailLabel(title: "산업 기능 요원 근무 여부")
    private let fieldTypeDetailStackView = FieldTypeDetailStackView()
    private let certificateLabel = RecruitmentDetailLabel(title: "자격증")
    private let recruitmentProcessLabel = RecruitmentDetailLabel(title: "선발 절차")
    private let requiredGradeLabel = RecruitmentDetailLabel(title: "기타 자격 요건")
    private let workingHoursLabel = RecruitmentDetailLabel(title: "근무시간")
//    private let awardedMoneyLabel = RecruitmentDetailLabel(title: "실습 수당")
//    private let permanentEmployeeLabel = RecruitmentDetailLabel(title: "정규직 전환 시")
    private let benefitsWelfareLabel = RecruitmentDetailLabel(title: "복리후생")
    private let needThingsLabel = RecruitmentDetailLabel(title: "제출 서류")
    private let otherMattersLabel = RecruitmentDetailLabel(title: "기타 사항")
    private var applyButton = JobisButton(style: .main).then {
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
            applyButton,
            bookmarkButton
        ].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)

        [
            recruitmentPeriodLabel,
            militaryServiceLabel,
            fieldTypeDetailStackView,
            certificateLabel,
            recruitmentProcessLabel,
            requiredGradeLabel,
            workingHoursLabel,
//            awardedMoneyLabel,
//            permanentEmployeeLabel,
            benefitsWelfareLabel,
            needThingsLabel,
            otherMattersLabel
        ].forEach(mainStackView.addArrangedSubview(_:))

        [
            companyProfileView,
            mainStackView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(applyButton.snp.top).inset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(mainStackView.snp.bottom).offset(20)
        }

        companyProfileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        mainStackView.snp.makeConstraints {
            $0.top.equalTo(companyProfileView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        applyButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(bookmarkButton.snp.leading).inset(-8)
        }

        bookmarkButton.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.centerY.equalTo(applyButton)
            $0.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher
            .map { RecruitmentDetailReactor.Action.fetchRecruitmentDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        companyProfileView.companyDetailButton.rx.tap
            .map { RecruitmentDetailReactor.Action.companyDetailButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .do(onNext: { [weak self] in
                self?.isBookmarked.toggle()
            })
            .map { RecruitmentDetailReactor.Action.bookmarkButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        applyButton.rx.tap
            .map { RecruitmentDetailReactor.Action.applyButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.compactMap { $0.recruitmentDetail }
            .bind { [weak self] detail in
                guard let self = self else { return }
                self.companyProfileView.setCompanyProfile(
                    imageUrl: detail.companyProfileURL,
                    companyName: detail.companyName
                )
                self.recruitmentPeriodLabel.setSubTitle(detail.period)
                self.militaryServiceLabel.setSubTitle("병역특례 \(detail.military ?? false ? "가능" : "불가능")")
                self.certificateLabel.setSubTitle(detail.requiredLicenses)
                self.recruitmentProcessLabel.setSubTitle(detail.hiringProgress)
                self.requiredGradeLabel.setSubTitle(detail.additionalQualifications)
                self.workingHoursLabel.setSubTitle(detail.workingHours)
                self.benefitsWelfareLabel.setSubTitle(detail.benefits)
                self.needThingsLabel.setSubTitle(detail.submitDocument)
                self.otherMattersLabel.setSubTitle(detail.etc)
                self.isBookmarked = detail.bookmarked
                self.fieldTypeDetailStackView.setFieldType(detail.areas)

                if UserDefaults.standard.string(forKey: "user_grade") != "3" {
                    self.applyButton.isEnabled = false
                    self.applyButton.setText("3학년만 지원할 수 있어요")
                } else {
                    detail.isApplicable ?
                    self.applyButton.setText("지원하기") :
                    self.applyButton.setText("이미 지원한 기업이에요")

                    self.applyButton.isEnabled = detail.isApplicable
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        companyProfileView.companyDetailButton.isHidden = reactor.currentState.type == .companyDetail

        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
                self?.navigationController?.navigationBar.prefersLargeTitles = false
            })
            .disposed(by: disposeBag)

        self.viewWillDisappearPublisher.asObservable()
            .bind { [weak self] in
                guard let self = self else { return }
                self.isPopViewController?(self.reactor.currentState.recruitmentID ?? 0, self.isBookmarked)
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}
