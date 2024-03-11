import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Kingfisher
import DesignSystem

public final class MyPageViewController: BaseViewController<MyPageViewModel> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let studentInfoView = StudentInfoView()
    private let editButton = UIButton(type: .system).then {
        $0.setJobisText("수정", font: .subHeadLine, color: .Primary.blue20)
    }
    private let reviewNavigateStackView = ReviewNavigateStackView()
    private let accountSectionView = AccountSectionView()
    private let bugSectionView = BugSectionView()
    private let helpSectionView = HelpSectionView()

    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        [
            studentInfoView,
            editButton,
            reviewNavigateStackView,
            helpSectionView,
            accountSectionView,
            bugSectionView
        ].forEach { self.contentView.addSubview($0) }
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.top.width.equalToSuperview()
            $0.bottom.equalTo(bugSectionView).offset(60)
        }

        studentInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalTo(studentInfoView)
            $0.trailing.equalToSuperview().offset(-28)
        }

        reviewNavigateStackView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(studentInfoView.snp.bottom)
        }

        helpSectionView.snp.makeConstraints {
            $0.top.equalTo(reviewNavigateStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        accountSectionView.snp.makeConstraints {
            $0.top.equalTo(helpSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        bugSectionView.snp.makeConstraints {
            $0.top.equalTo(accountSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }

    public override func bind() {
        let input = MyPageViewModel.Input(
            viewAppear: self.viewDidLoadPublisher,
            reviewNavigate: reviewNavigateStackView.reviewNavigateButtonDidTap,
            helpSectionDidTap: helpSectionView.getSelectedItem(type: .announcement),
            logoutSectionDidTap: accountSectionView.getSelectedItem(type: .logout),
            withdrawalSectionDidTap: accountSectionView.getSelectedItem(type: .withDraw)
        )
        let output = viewModel.transform(input)

        output.studentInfo.asObservable()
            .bind(onNext: { [weak self] in
                self?.studentInfoView.setStudentInfo(
                    profileImageUrl: $0.profileImageUrl,
                    gcn: $0.studentGcn,
                    name: $0.studentName,
                    department: $0.department.localizedString()
                )
            }).disposed(by: disposeBag)

        output.writableReviewList
            .bind(onNext: { [weak self] in
                self?.reviewNavigateStackView.setList(writableReviewCompanylist: $0)
            }).disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.showTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setLargeTitle(title: "마이페이지")
    }
}
