import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public class RecruitmentDetailViewController: BaseViewController<RecruitmentDetailViewModel> {
    static var companyID = 0

    var tableViewHeightConstraint: Constraint?
    var selectedIndexPath: IndexPath?
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
        $0.backgroundColor = .blue
    }
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "(주)비바리퍼블리카",
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
    private let recruitmentPeriodMenuLabel = JobisMenuLabel(text: "모집기간")
    private let recruitmentPeriodLabel = RecruitmentDetailLabel(text: "2023-03-13 ~ 2023-09-30")
    private let militaryServiceMenuLabel = JobisMenuLabel(text: "병역특례 여부")
    private let militaryServiceLabel = RecruitmentDetailLabel(text: "병역특례 가능")
    private let fieldTypeMenuLabel = JobisMenuLabel(text: "모집분야")
    private let fieldTypeDetailTableView = UITableView().then {
        $0.register(
            FieldTypeDetailViewCell.self,
            forCellReuseIdentifier: FieldTypeDetailViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 56
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    private let preferElemnetMenuLabel = JobisMenuLabel(text: "우대사항")
    private let preferElemnetLabel = RecruitmentDetailLabel(
        text: "React, Vue, Angular 등 SPA 프레임워크, UI/UX 에 대한 관심과 이해, Open API 기반 서버 시스템, 간단한 포토샵 역량, 원활한 OS 프로그램 활용 능력"
    )
    private let useTechniquesMenuLabel = JobisMenuLabel(text: "사용 기술")
    private let useTechniquesLabel = RecruitmentDetailLabel(
        text: "JavaScript, Java, HTML, Spring, MySQL, JavaScript, Jquery"
    )
    private let certificateMenuLabel = JobisMenuLabel(text: "자격증")
    private let certificateLabel = RecruitmentDetailLabel(text: "정보처리기능사, 정보처리기사, 정보처리기능사, 정보처리기사, 정보처리기능사")
    private let recruitmentProcessMenuLabel = JobisMenuLabel(text: "채용절차")
    private let recruitmentProcessLabel = RecruitmentDetailLabel(text: "알아서잘")
    private let requiredGradeMenuLabel = JobisMenuLabel(text: "필수 성적")
    private let requiredGradeLabel = RecruitmentDetailLabel(text: "-")
    private let workingHoursMenuLabel = JobisMenuLabel(text: "근무시간")
    private let workingHoursLabel = RecruitmentDetailLabel(text: "09:00 ~ 17:00")
    private let awardedMoneyMenuLabel = JobisMenuLabel(text: "실습 수당")
    private let awardedMoneyLabel = RecruitmentDetailLabel(text: "200 만원/월")
    private let permanentEmployeeMenuLabel = JobisMenuLabel(text: "정규직 전환 시")
    private let permanentEmployeeLabel = RecruitmentDetailLabel(text: "2400 만원/년")
    private let benefitsWelfareMenuLabel = JobisMenuLabel(text: "복리후생")
    private let benefitsWelfareLabel = RecruitmentDetailLabel(
        text: "자사 상품 할인 구매, 패밀리데이(매월 마지막주 금요일 16시 퇴근), 팀활동비/회식비 지원, 자율복장, 인센티브 지급, 명절 선물, 간식 지원, 자유로운 연차사용, 경조휴가 및 경소자비 지원, 개발에 필요한 최신형 장비 제공 (맥북 프로 M2, 듀얼 모니터 등), 중식 제공"
    )
    private let needThingsMenuLabel = JobisMenuLabel(text: "제출 서류")
    private let needThingsLabel = RecruitmentDetailLabel(text: "자기소개서, 학업계획서, 생활기록부")
    private let otherMattersMenuLabel = JobisMenuLabel(text: "기타 사항")
    private let otherMattersLabel = RecruitmentDetailLabel(text: "-")
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
        ].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        [
            companyLogoImageView,
            companyLabel,
            companyDetailButton,
            recruitmentPeriodMenuLabel,
            recruitmentPeriodLabel,
            militaryServiceMenuLabel,
            militaryServiceLabel,
            fieldTypeMenuLabel,
            fieldTypeDetailTableView,
            preferElemnetMenuLabel,
            preferElemnetLabel,
            useTechniquesMenuLabel,
            useTechniquesLabel,
            certificateMenuLabel,
            certificateLabel,
            recruitmentProcessMenuLabel,
            recruitmentProcessLabel,
            requiredGradeMenuLabel,
            requiredGradeLabel,
            workingHoursMenuLabel,
            workingHoursLabel,
            awardedMoneyMenuLabel,
            awardedMoneyLabel,
            permanentEmployeeMenuLabel,
            permanentEmployeeLabel,
            benefitsWelfareMenuLabel,
            benefitsWelfareLabel,
            needThingsMenuLabel,
            needThingsLabel,
            otherMattersMenuLabel,
            otherMattersLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }

    public override func setLayout() {
        companyLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }
        companyLabel.snp.makeConstraints {
            $0.left.equalTo(companyLogoImageView.snp.right).offset(10)
            $0.centerY.equalTo(companyLogoImageView)
        }
        companyDetailButton.snp.makeConstraints {
            $0.top.equalTo(companyLogoImageView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(supportButton.snp.top).inset(-12)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(otherMattersLabel.snp.bottom).offset(20)
        }
        supportButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(36)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(bookmarkButton.snp.left).inset(-8)
        }
        bookmarkButton.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(36)
            $0.right.equalToSuperview().inset(24)
        }
        recruitmentPeriodMenuLabel.snp.makeConstraints {
            $0.top.equalTo(companyDetailButton.snp.bottom).offset(12)
            $0.left.equalToSuperview()
        }
        recruitmentPeriodLabel.snp.makeConstraints {
            $0.top.equalTo(recruitmentPeriodMenuLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(24)
        }
        militaryServiceMenuLabel.snp.makeConstraints {
            $0.top.equalTo(recruitmentPeriodLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        militaryServiceLabel.snp.makeConstraints {
            $0.top.equalTo(militaryServiceMenuLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(24)
        }
        fieldTypeMenuLabel.snp.makeConstraints {
            $0.top.equalTo(militaryServiceLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        fieldTypeDetailTableView.snp.makeConstraints {
            $0.top.equalTo(fieldTypeMenuLabel.snp.bottom)
            $0.left.right.equalTo(view.safeAreaInsets)
            tableViewHeightConstraint = $0.height.greaterThanOrEqualTo(fieldTypeDetailTableView.contentSize.height + 4).constraint
        }
        preferElemnetMenuLabel.snp.makeConstraints {
            $0.top.equalTo(fieldTypeDetailTableView.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        preferElemnetLabel.snp.makeConstraints {
            $0.top.equalTo(preferElemnetMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        useTechniquesMenuLabel.snp.makeConstraints {
            $0.top.equalTo(preferElemnetLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        useTechniquesLabel.snp.makeConstraints {
            $0.top.equalTo(useTechniquesMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        certificateMenuLabel.snp.makeConstraints {
            $0.top.equalTo(useTechniquesLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        certificateLabel.snp.makeConstraints {
            $0.top.equalTo(certificateMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        recruitmentDetailSetLayout()
    }

    func recruitmentDetailSetLayout() {
        recruitmentProcessMenuLabel.snp.makeConstraints {
            $0.top.equalTo(certificateLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        recruitmentProcessLabel.snp.makeConstraints {
            $0.top.equalTo(recruitmentProcessMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        requiredGradeMenuLabel.snp.makeConstraints {
            $0.top.equalTo(recruitmentProcessLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        requiredGradeLabel.snp.makeConstraints {
            $0.top.equalTo(requiredGradeMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        workingHoursMenuLabel.snp.makeConstraints {
            $0.top.equalTo(requiredGradeLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        workingHoursLabel.snp.makeConstraints {
            $0.top.equalTo(workingHoursMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        awardedMoneyMenuLabel.snp.makeConstraints {
            $0.top.equalTo(workingHoursLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        awardedMoneyLabel.snp.makeConstraints {
            $0.top.equalTo(awardedMoneyMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        permanentEmployeeMenuLabel.snp.makeConstraints {
            $0.top.equalTo(awardedMoneyLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        permanentEmployeeLabel.snp.makeConstraints {
            $0.top.equalTo(permanentEmployeeMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        benefitsWelfareMenuLabel.snp.makeConstraints {
            $0.top.equalTo(permanentEmployeeLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        benefitsWelfareLabel.snp.makeConstraints {
            $0.top.equalTo(benefitsWelfareMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        needThingsMenuLabel.snp.makeConstraints {
            $0.top.equalTo(benefitsWelfareLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        needThingsLabel.snp.makeConstraints {
            $0.top.equalTo(needThingsMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
        otherMattersMenuLabel.snp.makeConstraints {
            $0.top.equalTo(needThingsLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview()
        }
        otherMattersLabel.snp.makeConstraints {
            $0.top.equalTo(otherMattersMenuLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = RecruitmentDetailViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            companyDetailButtonDidClicked: companyDetailButton.rx.tap.asSignal()
        )
        _ = viewModel.transform(input)
    }

    public override func configureViewController() {
        fieldTypeDetailTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        fieldTypeDetailTableView.delegate = self
        fieldTypeDetailTableView.dataSource = self

        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.hideTabbar()
            })
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .subscribe(onNext: {
                self.isBookmarked.toggle()
            })
            .disposed(by: disposeBag)

        supportButton.rx.tap
            .subscribe(onNext: {
                self.isSupported.toggle()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() { }

    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "contentSize", 
            let newContentSize = change?[.newKey] as? CGSize,
            let heightConstraint = tableViewHeightConstraint {
            heightConstraint.update(offset: newContentSize.height)
            view.layoutIfNeeded()
        }
    }

    deinit {
        fieldTypeDetailTableView.removeObserver(self, forKeyPath: "contentSize")
    }
}

extension RecruitmentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = fieldTypeDetailTableView.dequeueReusableCell(withIdentifier: FieldTypeDetailViewCell.identifier, for: indexPath)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        UIView.animate(withDuration: 0.3) {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return UITableView.automaticDimension
        } else {
            return 56
        }
    }
}
