import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Kingfisher
import DesignSystem

public class MyPageViewController: BaseViewController<MyPageViewModel> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let proFileView = ProfileView()
    let reviewNavigateStackView = ReviewNavigateStackView()
    let accountSectionView = SectionView().then {
        $0.titleLabel.setMenuLabel(text: "계정")
        $0.items = [
            ("관심분야 선택", .jobisIcon(.code)),
            ("비밀번호 변경", .jobisIcon(.changePassword)),
            ("로그아웃", .jobisIcon(.logout)),
            ("회원 탈퇴", .jobisIcon(.withdrawal))
        ]
    }
    let bugSectionView = SectionView().then {
        $0.titleLabel.setMenuLabel(text: "버그제보")
        $0.items = [
            ("버그 제보하기", .jobisIcon(.bugReport)),
            ("버그 제보함", .jobisIcon(.bugBox))
        ]
    }

    public override func attribute() {
        self.setLargeTitle(title: "마이페이지")
    }
    public override func bind() {
        let input = MyPageViewModel.Input(
            viewAppear: self.viewAppear,
            reviewNavigate: reviewNavigateStackView.reviewNavigateButtonDidTap
        )
        let output = viewModel.transform(input)
        output.studentInfo.asObservable()
            .bind(onNext: { [unowned self] in
                proFileView.userInfoLabel.text = "\($0.studentGcn) \($0.studentName)"
                proFileView.departmentLabel.text = $0.department.localizedString()
                proFileView.profileImageView
                    .kf.setImage(with: URL(string: "https://jobis-store.s3.ap-northeast-2.amazonaws.com/\($0.profileImageUrl)"))
            }).disposed(by: disposeBag)

        output.writableReviewList
            .bind(onNext: { [unowned self] in
                reviewNavigateStackView.setList(list: $0)
            }).disposed(by: disposeBag)
    }

    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        [
            proFileView,
            reviewNavigateStackView,
            accountSectionView,
            bugSectionView
        ].forEach { self.contentView.addSubview($0) }
    }
    public override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.top.width.equalToSuperview()
            $0.bottom.equalTo(bugSectionView)
        }
        proFileView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        reviewNavigateStackView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(proFileView.snp.bottom)
        }
        accountSectionView.snp.makeConstraints {
            $0.top.equalTo(reviewNavigateStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        bugSectionView.snp.makeConstraints {
            $0.top.equalTo(accountSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
