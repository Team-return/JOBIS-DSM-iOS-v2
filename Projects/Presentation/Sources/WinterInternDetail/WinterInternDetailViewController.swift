import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class WinterInternDetailViewController: BaseViewController<WinterInternDetailViewModel> {
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
    private let militaryServiceLabel = RecruitmentDetailLabel(title: "산업 기능 요원 근무 가능 여부")
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

    public override func bind() {
        let input = WinterInternDetailViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            companyDetailButtonDidClicked: companyProfileView.companyDetailButton.rx.tap.asSignal(),
            bookMarkButtonDidTap: bookmarkButton.rx.tap.asSignal()
                .do(onNext: { [weak self] in
                    self?.isBookmarked.toggle()
                }),
            applyButtonDidTap: applyButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)

        output.recruitmentDetailEntity.asObservable()
            .bind { [self] in
                viewModel.companyId = $0.companyID
                companyProfileView.setCompanyProfile(
                    imageUrl: $0.companyProfileURL,
                    companyName: $0.companyName
                )
                recruitmentPeriodLabel.setSubTitle($0.period)
                militaryServiceLabel.setSubTitle("병역특례 \($0.military ? "가능" : "불가능")")
                certificateLabel.setSubTitle($0.requiredLicenses)
                recruitmentProcessLabel.setSubTitle($0.hiringProgress)
                requiredGradeLabel.setSubTitle($0.requiredGrade)
                workingHoursLabel.setSubTitle($0.workingHours)
//                awardedMoneyLabel.setSubTitle("\($0.trainPay) 만원/월")
//                permanentEmployeeLabel.setSubTitle("\($0.pay ?? "0") 만원/년")
                benefitsWelfareLabel.setSubTitle($0.benefits)
                needThingsLabel.setSubTitle($0.submitDocument)
                otherMattersLabel.setSubTitle($0.etc)
                isBookmarked = $0.bookmarked
                viewModel.isApplicable = $0.isApplicable
            }.disposed(by: disposeBag)

        output.areaListEntity.asObservable()
            .bind {
                self.fieldTypeDetailStackView.setFieldType($0)
            }
            .disposed(by: disposeBag)

        output.isApplicable.asObservable()
            .bind { [weak self] isApplicable in
                if UserDefaults.standard.string(forKey: "user_grade") != "2" {
                    self?.applyButton.isEnabled = false
                    self?.applyButton.setText("지원하기")
                } else {
                    isApplicable ?
                    self?.applyButton.setText("지원하기") :
                    self?.applyButton.setText("이미 지원한 기업이에요")

                    self?.applyButton.isEnabled = isApplicable
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        companyProfileView.companyDetailButton.isHidden = viewModel.type == .companyDeatil

        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
                self?.navigationController?.navigationBar.prefersLargeTitles = false
            })
            .disposed(by: disposeBag)

        self.viewWillDisappearPublisher.asObservable()
            .bind {
                self.isPopViewController?(self.viewModel.recruitmentID!, self.isBookmarked)
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}
